//
//  FormPickerComponent.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/23/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol FormPickerComponentProtocol {
    var pickerData: [[String]] { get }
    var selectedValues: [String] { get }
    func setSelectedValues(_ values: [String]) throws
}

enum FormPickerComponentError: Error {
    case setSelectedValuesFailed(value: String, index: Int, message: String)
}

class FormPickerComponent: NSObject {
    // MARK: - Layers
    var delegate: FormComponentDelegate?
    
    // MARK: - Views
    private let componentView: FormComponentView
    private let label = UILabel()
    private let picker = UIPickerView()
    
    // MARK: - Exposed State
    let pickerData: [[String]]

    // MARK: - Init
    init(title: FormComponentView.Title, pickerData: [[String]]) {
        self.componentView = FormComponentView(title: title)
        self.pickerData = pickerData
        super.init()
        setUpComponentView()
        setUpPicker()
        updateLabel() // must be called after setUpPicker()
    }
    
    // MARK: - Helpers
    private func setUpComponentView() {
        componentView.rightItem = label
        componentView.bottomItem = picker
    }
    
    private func setUpPicker() {
        picker.dataSource = self
        picker.delegate = self
    }
    private func updateLabel() {
        label.text = selectedValues.joined(separator: " ")
    }
}

// MARK: - FormPickerComponentProtocol
extension FormPickerComponent: FormPickerComponentProtocol {
    
}

// MARK: - FormComponentProtocol
extension FormPickerComponent: FormComponentProtocol {
    var isValid: Bool { return true }
    var view: UIView { return componentView as UIView }
    
    func configureViewForMode(_ mode: FormComponentMode) {
        switch mode {
        case .unselected: componentView.mode = .bottomHidden
        case .selected: componentView.mode = .bottomShowing
        default: componentView.mode = .bottomHidden
        }
    }
    
    var selectedValues: [String] {
        var strings = [String]()
        for component in 0..<numberOfComponents(in: picker) {
            let selectedRow = picker.selectedRow(inComponent: component)
            let string = pickerData[component][selectedRow]
            strings.append(string)
        }
        return strings
    }
    
    func setSelectedValues(_ values: [String]) throws {
        var indices = [Int]()
        for (index, value) in values.enumerated() {
            guard let valueIndex = pickerData[index].index(where: { $0 == value }) else {
                throw FormPickerComponentError.setSelectedValuesFailed(value: value, index: index, message: "pickerData does not contain the passed-in value")
            }
            indices.append(valueIndex)
        }
        for (index, valueIndex) in indices.enumerated() {
            picker.selectRow(valueIndex, inComponent: index, animated: false)
        }
    }
}

// MARK: - UIPickerViewDataSource
extension FormPickerComponent: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
}

// MARK: - UIPickerViewDelegate
extension FormPickerComponent: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectValue(forComponent: self)
        updateLabel()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
}












