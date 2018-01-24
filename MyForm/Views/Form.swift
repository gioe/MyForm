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
//    var formAction: FormAction { get }
}

protocol FormDelegate: class {
    func didSelectComponent(_ component: FormComponent)
}

private struct Constants {
    static let wrapperTableViewCellIdentifer = "WrapperTableViewCell"
}

class Form: UIView {
    // MARK: - Layers
    weak var delegate: FormDelegate?
    
    // MARK: - Exposed State
    var isValid: Bool {
        for component in components {
            if !component.isValid { return false }
        }
        return true
    }
    
    // MARK: - Views
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    
    // MARK: - Exposed State
    let components: [FormComponent]
//    let formAction: FormAction
    
    // MARK: - Init
//    , formAction: @escaping FormAction
    init(components: [FormComponent]) {
        self.components = components
//        self.formAction = formAction
        super.init(frame: .zero)
        setUpConstraints()
        setUpStack()
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
    
    private func styleViews() {
        scrollView.backgroundColor = .lightGray
    }
}

extension Form: FormProtocol {
    
}










