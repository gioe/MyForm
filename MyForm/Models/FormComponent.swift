//
//  FormComponent.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/23/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

enum FormComponentMode {
    case unselected
    case selected
    case error
}

protocol FormComponentProtocol: ValidityAscerning {
    var delegate: FormComponentDelegate? { get set }
    var view: UIView { get }
    func configureViewForMode(_ mode: FormComponentMode)
}

protocol FormComponentDelegate {
    func didSelectValue(forComponent component: FormComponentProtocol)
}

enum FormComponent {
    case gap(CGFloat)
    case view(UIView)
    case picker(FormPickerComponent)
    case text(FormTextComponent)
    case custom(FormCustomComponent)
    
    var isValid: Bool {
        switch self {
        case .gap(_): return true
        case .view(_): return true
        case .picker(let component): return component.isValid
        case .text(let component): return component.isValid
        case .custom(let component): return component.isValid
        }
    }
    
    var view: UIView {
        switch self {
        case .gap(let height): return FormGapComponent(height: height)
        case .view(let view): return view
        case .picker(let component): return component.view
        case .text(let component): return component.view
        case .custom(let component): return component.view
        }
    }
}

class FormGapComponent: UIView {
    let height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
        super.init(frame: .zero)
        setUpConstraints()
        styleViews()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setUpConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
            ])
    }
    
    private func styleViews() {
        backgroundColor = .clear
    }
}





