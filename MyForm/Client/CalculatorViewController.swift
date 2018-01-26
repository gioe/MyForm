//
//  CalculatorViewController.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/24/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol CalculatorViewControllerProtocol where Self: UIViewController {
    
}

struct MyFood {
    let name: String
    let calories: Int
    let saturatedFat: Int
}

class CalculatorViewController: UIViewController {
    // MARK: - Views
    private let form = Form()
    
    // MARK: - Private State
    private let calories = CalculatorViewController.createCalories(key: Person.PersonCodingKeys.name)
    private let saturatedFat = CalculatorViewController.createSaturatedFat(key: Person.PersonCodingKeys.age)
    private let carbohydrates = CalculatorViewController.createCarbohydrates()
    private let fiber = CalculatorViewController.createFiber()
    private let sugar = CalculatorViewController.createSugar()
    private let protein = CalculatorViewController.createProtein()
    private let servings = CalculatorViewController.createServings()
    private let name = CalculatorViewController.createName()
    private let createFood = CalculatorViewController.createCreateFood()
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    // MARK: - View Life Cycle
    override func loadView() {
        view = form
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpForm()
    }
    
    // MARK: - Helpers
    private func setUpForm() {
        form.delegate = self
        form.components = [
            .view(CalculatorViewController.createNutritionalDetails()),
            .component(calories),
            .component(saturatedFat),
            .component(carbohydrates),
            .component(fiber),
            .component(sugar),
            .component(protein),
            .gap(8),
            .component(servings),
            .component(createFood)
        ]
    }
}

// MARK: - CalculatorViewControllerProtocol
extension CalculatorViewController: CalculatorViewControllerProtocol {}

// MARK: - FormDelegate
extension CalculatorViewController: FormDelegate {
    func didSelectValue(forComponent component: FormComponentProtocol) {
        print("did select value")
        evaluateForm()
    }
    
    private func evaluateForm() {
        
    }
}

// MARK: - Construction
extension CalculatorViewController {
    private static func createNutritionalDetails() -> UILabel {
        let label = UILabel()
        label.text = "NUTRITIONAL DETAILS"
        label.font = UIFont.systemFont(ofSize: 11)
        label.backgroundColor = .white
        return label
    }
    
    private static func createCalories(key: CodingKey? = nil) -> FormTextComponent {
        let component = FormTextComponent(title: FormComponentView.Title(string: "Calories", style: .major), key: key)
        component.placeholder = .optional
        return component
    }
    
    private static func createSaturatedFat(key: CodingKey? = nil) -> FormTextComponent {
        let component = FormTextComponent(title: FormComponentView.Title(string: "Saturated Fat", style: .major), key: key)
        component.placeholder = .required
        return component
    }
    
    private static func createCarbohydrates(key: CodingKey? = nil) -> FormTextComponent {
        let component = FormTextComponent(title: FormComponentView.Title(string: "Carbohydrates (g)", style: .major), key: key)
        component.placeholder = .optional
        return component
    }
    
    private static func createFiber(key: CodingKey? = nil) -> FormTextComponent {
        let component = FormTextComponent(title: FormComponentView.Title(string: "Fiber", style: .minor), key: key)
        component.placeholder = .optional
        return component
    }
    
    private static func createSugar(key: CodingKey? = nil) -> FormTextComponent {
        let component = FormTextComponent(title: FormComponentView.Title(string: "Sugar", style: .minor), key: key)
        component.placeholder = .required
        return component
    }
    
    private static func createProtein(key: CodingKey? = nil) -> FormTextComponent {
        let component = FormTextComponent(title: FormComponentView.Title(string: "Protein (g)", style: .major), key: key)
        component.placeholder = .required
        return component
    }
    
    private static func createServings(key: CodingKey? = nil) -> FormPickerComponent {
        let servingsData: [[String]] = [
            (0..<1000).map({ String($0) }),
            ["1/8", "1/4", "1/2"],
            ["servings", "oz", "gm"]
        ]
        let component = FormPickerComponent(title: FormComponentView.Title(string: "Servings", style: .major), pickerData: servingsData)
        return component
    }
    
    private static func createName(key: CodingKey? = nil) -> FormTextComponent {
        let component = FormTextComponent(title: FormComponentView.Title(string: "Name", style: .major), key: key)
        component.placeholder = .required
        return component
    }
    
    private static func createCreateFood(key: CodingKey? = nil) -> FormButtonComponent {
        let component = FormButtonComponent()
        component.button.setTitle("Create Food", for: .normal)
        return component
    }
}











