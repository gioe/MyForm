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

protocol FormComponentProtocol {
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
    case component(FormComponentProtocol)
}

extension FormComponent {
    var view: UIView {
        switch self {
        case .gap(let height): return FormGapComponent(height: height)
        case .view(let view): return view
        case .component(let component): return component.view
        }
    }
    
    func setDelegate(_ delegate: FormComponentDelegate?) {
        switch self {
        case .component(var component): component.delegate = delegate
        default: return
        }
    }
    
    func configureViewForMode(_ mode: FormComponentMode) {
        switch self {
        case .component(let component): component.configureViewForMode(mode)
        default: return
        }
    }
}

extension FormComponent: Equatable {
    static func == (l: FormComponent, r: FormComponent) -> Bool {
        return l.view === r.view
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





