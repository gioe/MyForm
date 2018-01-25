//
//  FormButtonComponent.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/25/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol FormButtonComponentProtocol {
    var button: UIButton { get }
}

class FormButtonComponent {
    // MARK: - Layers
    var delegate: FormComponentDelegate?
    
    // MARK: - Views
    let componentView = FormButtonComponentView()
}

// MARK: - FormButtonComponentProtocol
extension FormButtonComponent: FormButtonComponentProtocol {
    var button: UIButton {
        return componentView.button
    }
}

// MARK: - FormComponentProtocol
extension FormButtonComponent: FormComponentProtocol {
    var view: UIView {
        return componentView as UIView
    }
    
    func configureViewForMode(_ mode: FormComponentMode) {
        return
    }
}
