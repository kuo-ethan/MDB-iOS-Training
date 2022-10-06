//
//  RollCallVC.swift
//  CalHacksDemo
//
//  Created by Michael Lin on 8/26/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class RollCallVC: UIViewController {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Placeholder"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let presentButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "checkmark.circle.fill") // Using an SF symbol
        config.title = "Present"
        config.baseBackgroundColor = .systemGreen // background color
        config.baseForegroundColor = .systemGreen // text color
        config.imagePadding = 10
        config.buttonSize = .large
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let absentButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "xmark.circle.fill") // Using an SF symbol
        config.title = "Absent"
        config.baseBackgroundColor = .systemRed // system colors are adaptable
        config.baseForegroundColor = .systemRed
        config.imagePadding = 10
        config.buttonSize = .large
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(nameLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 50
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.centerXAnchor.constraint(equalTo: stack.centerXAnchor)
        ])
        
        let innerStack = UIStackView()
        innerStack.axis = .vertical
        innerStack.addArrangedSubview(absentButton)
        innerStack.addArrangedSubview(presentButton)
        innerStack.spacing = 20
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(innerStack)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: innerStack.leadingAnchor, constant: -50),
            view.trailingAnchor.constraint(equalTo: innerStack.trailingAnchor, constant: 50)
        ])
        
        presentButton.addAction(UIAction() { _ in // if closure is last parameter, can write it outside
            Roster.main.name(self.nameLabel.text!, isPresent: true)
            self.showNextNameOrResult()
        }, for: .touchUpInside)
        
        absentButton.addAction(UIAction() { _ in // if closure is last parameter, can write it outside
            Roster.main.name(self.nameLabel.text!, isPresent: false)
            self.showNextNameOrResult()
        }, for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // Different than viewDidLoad, called when switch to this ViewController
        super.viewWillAppear(animated)
        nameLabel.text = Roster.main.nextName()
    }
    
    
    private func showNextNameOrResult() {
        if let name = Roster.main.nextName() {
            setUserInteractionEnabled(to: false) // Don't take in user input temporarily
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { // Fade out
                self.nameLabel.alpha = 0 //
            }, completion: { _ in
                self.nameLabel.text = name
                self.setUserInteractionEnabled(to: true)
                UIView.animate(withDuration: 0.3, animations: { // Fade in
                    self.nameLabel.alpha = 1
                })
            })
        } else {
            let vc = ResultVC()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }

    private func setUserInteractionEnabled(to value: Bool) {
        presentButton.isUserInteractionEnabled = value
        absentButton.isUserInteractionEnabled = value
    }
}
