//
//  FormTextComponent.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/23/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol FormTextComponentProtocol {
    var keyboardType: UIKeyboardType { get set }
    var placeholder: FormTextComponent.Placeholder { get set }
    var selectedValue: String? { get set }
}

class FormTextComponent: NSObject {
    // MARK: - Namespaced
    enum Placeholder {
        case required
        case optional
        case custom(String)
        
        var string: String {
            switch self {
            case .required: return "required"
            case .optional: return "optional"
            case .custom(let string): return string
            }
        }
    }
    
    // MARK: - Layers
    var delegate: FormComponentDelegate?
    
    var key: CodingKey?
    var outPut: [String : Any] = [:]
    
    // MARK: - Exposed State
    var placeholder: FormTextComponent.Placeholder = .optional {
        didSet { configurePlaceholder(placeholder) }
    }
    
    // MARK: - Private State
    private let componentView: FormComponentView
    private let textField = UITextField()

    // MARK: - Init
    init(title: FormComponentView.Title, key: CodingKey?) {
        self.key = key
        self.componentView = FormComponentView(title: title)
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
    
    // MARK: - didSet
    private func configurePlaceholder(_ placeholder: Placeholder) {
        textField.placeholder = placeholder.string
    }
}

// MARK: - FormTextComponentProtocol
extension FormTextComponent: FormTextComponentProtocol {
    var keyboardType: UIKeyboardType {
        get { return textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    var selectedValue: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
}

// MARK: - FormComponentProtocol
extension FormTextComponent: FormComponentProtocol {
    var view: UIView {
        return componentView as UIView
    }
    
    func configureViewForMode(_ mode: FormComponentMode) {
        switch mode {
        case .selected: textField.becomeFirstResponder()
        case .unselected: textField.resignFirstResponder()
        default: textField.resignFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate
extension FormTextComponent: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let key = key, let text = textField.text {
            outPut = [key.stringValue : text]
        }
        
        delegate?.didSelectValue(forComponent: self)
    }
}













