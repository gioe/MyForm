//
//  Form.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/23/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

/* What should Form do for you?
 - convenient form construction
 - delegate interaction events
 - setting form component values (maybe a job for FormComponent)
 - respond to keyboard presentation (maybe a job for FormViewController; maybe its automatically handled by the table view method scrollToRow())
 */

/* What should FormComponent do for you?
 - delegate value selection events
 - inject aesthetic / display configuration
 */

typealias FormAction = () -> Void
protocol FormProtocol: ValidityAscerning {
    var delegate: FormDelegate? { get set }
    var components: [FormComponent] { get }
    var formAction: FormAction { get }
}

protocol FormDelegate: class {
    func didSelectComponent(_ component: FormComponent)
}

private struct Constants {
    static let wrapperTableViewCellIdentifer = "WrapperTableViewCell"
    static let selectionAnimationDuration: TimeInterval = 0.25
}

class Form: UIView {
    // MARK: - Layers
    weak var delegate: FormDelegate?
    
    // MARK: - Views
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    
    // MARK: - Interactions
    private let tap = UITapGestureRecognizer()
    
    // MARK: - Exposed State
    let components: [FormComponent]
    let formAction: FormAction
    
    // MARK: - Private State
    private var selectedComponent: FormComponent? {
        didSet { configureSelectedComponent(forNew: selectedComponent, old: oldValue) }
    }
    
    // MARK: - Init
    init(components: [FormComponent], formAction: @escaping FormAction) {
        self.components = components
        self.formAction = formAction
        super.init(frame: .zero)
        setUpConstraints()
        setUpStack()
        setUpComponents()
        setUpTap()
        styleViews()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    // MARK: - Helpers
    private func setUpConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stack.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            NSLayoutConstraint(item: stack, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0.0)
            ])
    }
    
    private func setUpStack() {
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 0.5
        components
            .map({ $0.view })
            .forEach({ stack.addArrangedSubview($0) })
    }
    
    private func setUpComponents() {
        components.forEach({
            $0.setDelegate(self)
            $0.view.isUserInteractionEnabled = true // to enable hit-testing
        })
    }
    
    private func setUpTap() {
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = true
        tap.delaysTouchesBegan = false
        tap.delaysTouchesEnded = false
        tap.addTarget(self, action: #selector(didTap(sender:)))
        addGestureRecognizer(tap)
    }
    
    private func styleViews() {
        scrollView.backgroundColor = .lightGray
    }
    
    // MARK: - didSet
    private func configureSelectedComponent(forNew new: FormComponent?, old: FormComponent?) {
        old?.configureViewMode(.unselected)
        new?.configureViewMode(.selected)
        if let new = new {
            let converted = scrollView.convert(new.view.frame, from: new.view.superview)
            scrollView.scrollRectToVisible(converted, animated: true)
        }
        UIView.animate(withDuration: Constants.selectionAnimationDuration, animations: { self.layoutIfNeeded() })
    }
    
    // MARK: - View Actions
    @objc private func didTap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        if let component = componentForPoint(point) {
            // if the selected component was tapped, unselect it
            guard component != selectedComponent else {
                selectedComponent = nil
                return
            }
            selectedComponent = component
        }
    }
    
    private func componentForPoint(_ point: CGPoint) -> FormComponent? {
        guard var hit = hitTest(point, with: nil) else { return nil }
        while hit !== self {
            if let index = components.index(where: { $0.view === hit }) {
                return components[index]
            }
            if let superview = hit.superview { hit = superview }
            else { break }
        }
        return nil
    }
}

// MARK: - FormProtocol
extension Form: FormProtocol {
    
}

// MARK: - ValidityAscerning
extension Form: ValidityAscerning {
    var isValid: Bool {
        for component in components {
            if !component.isValid { return false }
        }
        return true
    }
}

// MARK: - FormComponentDelegate
extension Form: FormComponentDelegate {
    func didSelectValue(forComponent component: FormComponentProtocol) {
        
    }
}











