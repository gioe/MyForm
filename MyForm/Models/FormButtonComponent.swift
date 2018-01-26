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
    
    var key: CodingKey? = Person.PersonCodingKeys.age
    var outPut: [String : Any] = [:]
    
    // MARK: - Views
    let componentView = FormButtonComponentView()
    
    @objc func didSelectButton() {
        delegate?.didSubmitForm(forComponent: self)
    }
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
        button.addTarget(self, action: #selector(didSelectButton), for:.touchUpInside)
        return
    }
}
