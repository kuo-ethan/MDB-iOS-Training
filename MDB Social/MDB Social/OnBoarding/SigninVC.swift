//
//  SigninVC.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import UIKit
import NotificationBannerSwift

/* The starting sign in page. */

class SigninVC: UIViewController {
    
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
        lbl.text = "Welcome,"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let titleSecLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign in to continue"
        lbl.textColor = .secondaryText
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let emailTextField: AuthTextField = {
        let tf = AuthTextField(title: "Email:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Password:")
        tf.textField.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let signinButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Sign In", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let signUpActionLabel: HorizontalActionLabel = {
        let actionLabel = HorizontalActionLabel(
            label: "Don't have an account?",
            buttonTitle: "Sign Up")
        
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        return actionLabel
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    private let signinButtonHeight: CGFloat = 44.0

    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        view.addSubview(titleSecLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: contentEdgeInset.top),
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
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleSecLabel.bottomAnchor,
                                       constant: 60)
        ])
        
        view.addSubview(signinButton)
        NSLayoutConstraint.activate([
            signinButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            signinButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            signinButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            signinButton.heightAnchor.constraint(equalToConstant: signinButtonHeight)
        ])
        
        signinButton.layer.cornerRadius = signinButtonHeight / 2
        
        signinButton.addTarget(self, action: #selector(didTapSignIn(_:)), for: .touchUpInside)
        
        view.addSubview(signUpActionLabel)
        NSLayoutConstraint.activate([
            signUpActionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpActionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
        
        signUpActionLabel.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }

    @objc private func didTapSignIn(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "" else {
            showErrorBanner(withTitle: "Missing email", subtitle: "Please enter you email address")
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            showErrorBanner(withTitle: "Missing password", subtitle: "Please enter your password")
            return
        }
        
        signinButton.showLoading()
        Authentication.shared.signIn(withEmail: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            defer {
                self.signinButton.hideLoading()
            }
            
            switch result {
            case .success:
                guard let window = self.view.window else { return }
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                window.rootViewController = vc
                let options: UIView.AnimationOptions = .transitionCrossDissolve
                let duration: TimeInterval = 0.3
                UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
                
            case .failure(let error):
                switch error {
                case .userNotFound:
                    self.showErrorBanner(withTitle: "User not found", subtitle: "Please check your email address")
                case .wrongPassword:
                    self.showErrorBanner(withTitle: "Incorrect password", subtitle: "Please check your password")
                case .invalidEmail:
                    self.showErrorBanner(withTitle: "Not a valid email", subtitle: "Please check your email address")
                default:
                    self.showErrorBanner(withTitle: "Internal error", subtitle: "")
                }
            }
        }
    }
    
    @objc private func didTapSignUp(_ sender: UIButton) {
        let vc = SignupVC()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        showBanner(withStyle: .warning, title: title, subtitle: subtitle)
    }
    
    private func showBanner(withStyle style: BannerStyle, title: String, subtitle: String?) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: .systemFont(ofSize: 14, weight: .regular),
                                                style: style)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}
