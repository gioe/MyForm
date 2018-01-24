//
//  FormComponentView.swift
//  MyForm
//
//  Created by Trevor Beasty on 1/23/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import UIKit

protocol FormComponentViewProtocol {
    var title: FormComponentView.Title { get }
    var rightItem: UIView? { get set }
    var bottomItem: UIView? { get set }
}

private struct Constants {
    static let topContainerHeight: CGFloat = 50
    static let bottomContainerHeight: CGFloat = 120
    static let rightItemWidth: CGFloat = 100
}

class FormComponentView: UIView {
    // MARK: - Namespaced
    enum TitleStyle {
        case major
        case minor
        
        var inset: CGFloat {
            switch self {
            case .major: return 10
            case .minor: return 60
            }
        }
        
        var attributes: [NSAttributedStringKey:Any] {
            return [:]
        }
    }
    
    struct Title {
        let string: String
        let style: TitleStyle
    }
    
    // MARK: - Views
    private let titleLabel = UILabel()
    private let topContainer = UIView()
    private let bottomContainer = UIView()
    
    // MARK: - Exposed State
    let title: Title
    var rightItem: UIView? {
        didSet { configureRightItem(forNew: rightItem, old: oldValue) }
    }
    var bottomItem: UIView? {
        didSet { configureBottomItem(forNew: bottomItem, old: oldValue) }
    }

    // MARK: - Init
    init(title: Title) {
        self.title = title
        super.init(frame: .zero)
        setUpConstraints()
        configureDisplay()
        styleViews()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    // MARK: - Helpers
    private func setUpConstraints() {
        [topContainer, bottomContainer].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        })
        let bottomContainerDefaultHeight = bottomContainer.heightAnchor.constraint(equalToConstant: 0)
        bottomContainerDefaultHeight.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            topContainer.leftAnchor.constraint(equalTo: leftAnchor),
            topContainer.rightAnchor.constraint(equalTo: rightAnchor),
            topContainer.topAnchor.constraint(equalTo: topAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: Constants.topContainerHeight),
            bottomContainer.leftAnchor.constraint(equalTo: leftAnchor),
            bottomContainer.rightAnchor.constraint(equalTo: rightAnchor),
            bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomContainerDefaultHeight
            ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: topContainer.leftAnchor, constant: title.style.inset),
            titleLabel.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor)
            ])
    }
    
    private func configureDisplay() {
        let attributedTitle = NSAttributedString(string: title.string, attributes: title.style.attributes)
        titleLabel.attributedText = attributedTitle
    }
    
    private func styleViews() {
        backgroundColor = .white
    }
    
    // MARK: - didSet
    private func configureRightItem(forNew new: UIView?, old: UIView?) {
        old?.removeFromSuperview()
        
        if let new = new {
            new.translatesAutoresizingMaskIntoConstraints = false
            topContainer.addSubview(new)
            NSLayoutConstraint.activate([
                new.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -10),
                new.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
                new.widthAnchor.constraint(equalToConstant: Constants.rightItemWidth)
                ])
        }
    }
    
    private func configureBottomItem(forNew new: UIView?, old: UIView?) {
        old?.removeFromSuperview()
        
        if let new = new {
            new.translatesAutoresizingMaskIntoConstraints = false
            bottomContainer.addSubview(new)
            NSLayoutConstraint.activate([
                new.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor),
                new.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor),
                new.topAnchor.constraint(equalTo: bottomContainer.topAnchor),
                new.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor),
                new.heightAnchor.constraint(equalToConstant: Constants.bottomContainerHeight)
                ])
        }
    }
}

// MARK: - FormComponentViewProtocol
extension FormComponentView: FormComponentViewProtocol {
    
}











