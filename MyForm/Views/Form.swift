//
//  Form.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/23/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol FormProtocol {
    var delegate: FormDelegate? { get set }
    var components: [FormComponent] { get set }
    associatedtype FormType
    var type: FormType { get set }
}

protocol FormDelegate: class {
    func didSelectValue(forComponent component: FormComponentProtocol)
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
    var components: [FormComponent] = [] {
        didSet { configureComponents(forNew: components, old: oldValue) }
    }
    
    // MARK: - Private State
    private var selectedComponent: FormComponent? {
        didSet { configureSelectedComponent(forNew: selectedComponent, old: oldValue) }
    }
    
    public var type = Person.self
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setUpConstraints()
        setUpStack()
        setUpTap()
        styleViews()
        setUpKeyboardNotifications()
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
    
    private func setUpKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - didSet
    private func configureSelectedComponent(forNew new: FormComponent?, old: FormComponent?) {
        old?.configureViewForMode(.unselected)
        new?.configureViewForMode(.selected)
        UIView.animate(
            withDuration: Constants.selectionAnimationDuration,
            animations: { self.layoutIfNeeded() },
            completion: { _ in if let new = new { self.scrollComponentToVisible(new) } }
        )
    }
    
    private func configureComponents(forNew new: [FormComponent], old: [FormComponent]) {
        old.forEach { $0.setDelegate(nil) }
        stack.arrangedSubviews.forEach { stack.removeArrangedSubview($0) }
        
        new.forEach {
            $0.setDelegate(self)
            $0.view.isUserInteractionEnabled = true // to enable hit-testing
            stack.addArrangedSubview($0.view)
        }
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
    
    private func scrollComponentToVisible(_ component: FormComponent) {
        let converted = scrollView.convert(component.view.frame, from: component.view.superview)
        scrollView.scrollRectToVisible(converted, animated: true)
    }
    
    // MARK: - Keyboard Actions
    @objc private func keyboardWillShow(sender: Notification) {
        guard let userInfo = sender.userInfo, let keyboardFinalFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        let convertedFrame = self.convert(frame, to: nil)
        let intersect: CGFloat = convertedFrame.origin.y + convertedFrame.height - keyboardFinalFrame.origin.y
        scrollView.contentInset.bottom = intersect
    }
    
    @objc private func keyboardWillHide(sender: Notification) {
        scrollView.contentInset.bottom = 0
    }
}

// MARK: - FormProtocol
extension Form: FormProtocol {}

// MARK: - FormComponentDelegate
extension Form: FormComponentDelegate {
    func didSubmitForm(forComponent component: FormComponentProtocol) {}
    
    func didSelectValue(forComponent component: FormComponentProtocol) {
        delegate?.didSelectValue(forComponent: component)
    
        //decode creates a model fr
        
        guard let data = try? JSONSerialization.gie/data(withJSONObject: component.outPut, options: []), let parsedData = try? JSONDecoder().decode(type, from: data) else {
            return
        }
        print(parsedData)
    }
}
