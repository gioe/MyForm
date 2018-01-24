//
//  FormViewController.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/24/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol FormViewControllerProtocol {
    var form: Form { get }
}

class FormViewController: UIViewController {
    // MARK: - Views
    let form: Form
    
    // MARK: - Init
    init(form: Form) {
        self.form = form
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        self.view = form
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardNotifications()
    }
    
    // MARK: - Helpers
    private func setUpKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Keyboard Actions
    @objc private func keyboardWillShow(sender: Notification) {
        
    }
    
    @objc private func keyboardWillHide(sender: Notification) {
        
    }
}

// MARK: - FormViewControllerProtocol
extension FormViewController: FormViewControllerProtocol {
    
}
