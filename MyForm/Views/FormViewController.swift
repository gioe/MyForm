//
//  FormViewController.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/24/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

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
}
