//
//  FormCustomComponent.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/23/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

class FormCustomComponent: FormComponentProtocol {
    var isValid: Bool = false
    var delegate: FormComponentDelegate?
    let view = UIView()
    func configureViewForMode(_ mode: FormComponentMode) {
        
    }
}
