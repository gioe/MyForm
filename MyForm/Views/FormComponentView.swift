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
    var mode: FormComponentView.Mode { get set }
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
    
    enum Mode {
        case bottomShowing
        case bottomHidden
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
    var mode: Mode = .bottomHidden {
        didSet { configureMode(mode) }
    }
    
    // MARK: - Private State
    private var modeConstraints = [NSLayoutConstraint]()

    // MARK: - Init
    init(title: Title) {
        defer { mode = .bottomHidden }
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
        
        NSLayoutConstraint.activate([
            topContainer.leftAnchor.constraint(equalTo: leftAnchor),
            topContainer.rightAnchor.constraint(equalTo: rightAnchor),
            topContainer.topAnchor.constraint(equalTo: topAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: Constants.topContainerHeight),
            bottomContainer.leftAnchor.constraint(equalTo: leftAnchor),
            bottomContainer.rightAnchor.constraint(equalTo: rightAnchor),
            bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: Constants.bottomContainerHeight)
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
        clipsToBounds = true
        backgroundColor = .white
    }
    
    // MARK: - didSet
    private func configureRightItem(forNew new: UIView?, old: UIView?) {
        old?.removeFromSuperview()
        
        if let new = new {
            new.translatesAutoresizingMaskIntoConstraints = false
            self.topContainer.addSubview(new)
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
                ])
        }
    }
    
    private func configureMode(_ mode: Mode) {
        NSLayoutConstraint.deactivate(modeConstraints)
        let bottom: NSLayoutConstraint
        switch mode {
        case .bottomHidden: bottom = bottomAnchor.constraint(equalTo: topContainer.bottomAnchor)
        case .bottomShowing: bottom = bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor)
        }
        NSLayoutConstraint.activate([bottom])
        modeConstraints = [bottom]
    }
}

// MARK: - FormComponentViewProtocol
extension FormComponentView: FormComponentViewProtocol {
    
}











