//
//  SignUpVC.swift
//  MDB Social
//
//  Created by Ethan Kuo on 11/2/22.
//

import Foundation
import UIKit
import NotificationBannerSwift

class SignUpVC: UIViewController {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign up"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let titleSecLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Post and RSVP to socials today!"
        lbl.textColor = .secondaryText
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let fullNameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Full Name:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let emailTextField: AuthTextField = {
        let tf = AuthTextField(title: "Email:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let userNameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Username:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Password:")
        tf.textField.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let confirmPasswordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Confirm Password:")
        tf.textField.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let signUpButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    private let signUpButtonHeight: CGFloat = 44.0

    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        view.addSubview(titleSecLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: contentEdgeInset.right),
            titleSecLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: 3),
            titleSecLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleSecLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        view.addSubview(stack)
        stack.addArrangedSubview(fullNameTextField)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(userNameTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(confirmPasswordTextField)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleSecLabel.bottomAnchor,
                                       constant: 40)
        ])
        
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            signUpButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: signUpButtonHeight)
        ])
        
        signUpButton.layer.cornerRadius = signUpButtonHeight / 2
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapSignUp(_ sender: UIButton) {
        
    }
}
