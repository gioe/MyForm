//
//  MyFormClient.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/24/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol MyFormClientProtocol {
    static func calculator() -> FormViewController
}

class MyFormClient {
    
}

// MARK: - MyFormClientProtocol
extension MyFormClient: MyFormClientProtocol {
    static func calculator() -> FormViewController {
        let nutritionalDetails = UILabel()
        nutritionalDetails.text = "NUTRITIONAL DETAILS"
        nutritionalDetails.backgroundColor = .white
        let isInt: TextValidator = { string in
            guard let _ = Int(string) else { return false }
            return true
        }
        let calories = FormTextComponent(title: FormComponentView.Title(string: "Calories", style: .major), textValidator: isInt)
        calories.placeholder = "required"
        let fat = FormTextComponent(title: FormComponentView.Title(string: "Fat (g)", style: .major), textValidator: isInt)
        fat.placeholder = "optional"
        let saturatedFat = FormTextComponent(title: FormComponentView.Title(string: "Saturated Fat (g)", style: .minor), textValidator: isInt)
        saturatedFat.placeholder = "required"
        let servingsData: [[String]] = [
            (0..<1000).map({ String($0) }),
            ["1/8", "1/4", "1/2"],
            ["servings", "oz", "gm", "cups"]
        ]
        let servings = FormPickerComponent(title: FormComponentView.Title(string: "Servings", style: .major), pickerData: servingsData)
        let name = FormTextComponent(title: FormComponentView.Title(string: "Name", style: .major), textValidator: { _ in return true })
        name.placeholder = "required"
        
        let components: [FormComponent] = [
            .view(nutritionalDetails),
            .text(calories),
            .text(fat),
            .text(saturatedFat),
            .gap(10),
            .picker(servings),
            .text(name)
        ]
        
        let form = Form(components: components, formAction: { return })
        return FormViewController(form: form)
    }
}
