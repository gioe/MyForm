//
//  FormTextComponent.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/23/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

typealias TextValidator = (String) -> Bool
protocol FormTextComponentProtocol {
    var textValidator: TextValidator { get }
    var keyboardType: UIKeyboardType { get set }
    var placeholder: String? { get set }
}

class FormTextComponent: NSObject {
    // MARK: - Layers
    var delegate: FormComponentDelegate?
    
    // MARK: - Exposed State
    let textValidator: (String) -> Bool
    
    // MARK: - Private State
    private let componentView: FormComponentView
    private let textField = UITextField()

    // MARK: - Init
    init(title: FormComponentView.Title, textValidator: @escaping TextValidator) {
        self.componentView = FormComponentView(title: title)
        self.textValidator = textValidator
        super.init()
        setUpComponentView()
        setUpTextField()
        styleViews()
    }
    
    // MARK: - Helpers
    private func setUpComponentView() {
        componentView.rightItem = textField
    }
    
    private func setUpTextField() {
        textField.delegate = self
    }
    
    private func styleViews() {
        
    }
}

// MARK: - FormTextComponentProtocol
extension FormTextComponent: FormTextComponentProtocol {
    var keyboardType: UIKeyboardType {
        get { return textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    var placeholder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
}

// MARK: - FormComponentProtocol
extension FormTextComponent: FormComponentProtocol {
    var isValid: Bool {
        guard let text = textField.text else { return false }
        return textValidator(text)
    }
    
    var view: UIView {
        return componentView as UIView
    }
    
    func configureViewForMode(_ mode: FormComponentMode) {
        return
    }
}

// MARK: - UITextFieldDelegate
extension FormTextComponent: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didSelectValue(forComponent: self)
    }
}














