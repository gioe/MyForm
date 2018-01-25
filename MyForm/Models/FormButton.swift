//
//  FormButton.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/24/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol FormButtonProtocol {
    var title: String { get }
    var isEnabled: Bool { get set }
}

class FormButton: UIView {
    // MARK: - Views
    private let button = UIButton()
    
    // MARK: - Exposed State
    let title: String
    
    // MARK: - Init
    init(title: String) {
        self.title = title
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
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            ])
    }
    
    private func styleViews() {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.setTitle(title, for: .normal)
    }
}

// MARK: - FormButtonProtocol
extension FormButton: FormButtonProtocol {
    var isEnabled: Bool {
        get { return button.isEnabled }
        set { button.isEnabled = newValue }
    }
}
