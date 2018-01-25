//
//  FormButtonComponentView.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/25/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol FormButtonComponentViewProtocol where Self: UIView {
    var button: UIButton { get }
}

class FormButtonComponentView: UIView {
    // MARK: - Views
    let button = UIButton()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setUpConstraints()
        styleViews()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    // MARK: - Helpers
    private func setUpConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: 5),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)
            ])
    }
    
    private func styleViews() {
        backgroundColor = .clear
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
    }
}

// MARK: - FormButtonComponentViewProtocol
extension FormButtonComponentView: FormButtonComponentViewProtocol {}
