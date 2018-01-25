//
//  CalculatorViewController.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/24/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    // MARK: - Form Components
    let nutritionalDetails: UILabel = {
        let label = UILabel()
        label.text = "NUTRITIONAL DETAILS"
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    let calories: FormTextComponent = {
        let component = FormTextComponent(title: FormComponentView.Title(string: "Calories", style: .major))
        component.placeholder = .optional
        return component
    }()
    
    let saturatedFat: FormTextComponent = {
        let component = FormTextComponent(title: FormComponentView.Title(string: "Saturated Fat", style: .major))
        component.placeholder = .required
        return component
    }()
}
