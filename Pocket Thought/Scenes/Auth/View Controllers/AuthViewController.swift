//
//  AuthViewController.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 17/07/24.
//

import UIKit

class AuthViewController : UIViewController {
    
    var isSignedUp : Bool = false
    
    // MARK: -- View Components --
    var signUpLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Sign Up"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var emailTextField : UITextView = {
        let textField = UITextView(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 12
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    var emailLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Email"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var passwordLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var passwordTextField : UITextView = {
        let textField = UITextView(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 12
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    var signInButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.textColor = UIColor.black
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var signInWithGoogleButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var authToggleButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var authLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: -- View Models --
    var viewModel : AuthViewModelInputDelegate! {
        didSet{
            viewModel.viewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.start()
        setupContents()
        setupConstraints()
    }
    
    deinit {
        viewModel.finish()
    }
    
    private func setupContents () {
        let signUpTitle = isSignedUp ? "Sign in" : "Sign up"
        let signUpGoogleTitle = isSignedUp ? "Sign in with google" : "Sign up with google"
        let authTitle = isSignedUp ? "Don't have an account?" : "Already have an account?"
        signInButton.setTitle(signUpTitle, for: .normal)
        signInWithGoogleButton.setTitle(signUpGoogleTitle, for: .normal)
        authLabel.text = authTitle
        authToggleButton.setTitle(isSignedUp ? "Sign up" : "Sign in", for: .normal)
        
        let signUpAction = UIAction {[weak self] _ in
            guard let self else { return }
            viewModel.didTapSignUp(email: emailTextField.text, password: passwordTextField.text)
        }
        
        let signInAction = UIAction {[weak self] _ in
            guard let self else { return }
            viewModel.didTapSignInWithEmail(email: emailTextField.text, password: passwordTextField.text)
        }
        
        let signUpGoogleAction = UIAction {[weak self] _ in
            guard let self else { return }
            viewModel.didTapSignUp(email: emailTextField.text, password: passwordTextField.text)
        }
        
        if isSignedUp {
            signInButton.removeAllActions()
            signInButton.addAction(signInAction, for: .touchUpInside)
        }
        else {
            signInButton.removeAllActions()
            signInButton.addAction(signUpAction, for: .touchUpInside)
        }

    }
    
    private func setupConstraints(){
        view.addSubview(emailTextField)
        view.addSubview(emailLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordLabel)
        view.addSubview(signInButton)
        view.addSubview(signInWithGoogleButton)
        view.addSubview(authLabel)
        view.addSubview(authToggleButton)
        
        let toggleAction = UIAction { [weak self] _ in
            guard let self else {return }
            isSignedUp.toggle()
            setupContents()
        }
        authToggleButton.addAction(toggleAction, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -5),
            emailLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            passwordLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            signInButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            
            signInWithGoogleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 5),
            signInWithGoogleButton.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            signInWithGoogleButton.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
            signInWithGoogleButton.heightAnchor.constraint(equalToConstant: 40),
            
            authLabel.topAnchor.constraint(equalTo: signInWithGoogleButton.bottomAnchor, constant: 10),
            authLabel.leadingAnchor.constraint(equalTo: signInWithGoogleButton.leadingAnchor),
            
            authToggleButton.leadingAnchor.constraint(equalTo: authLabel.trailingAnchor, constant: 10),
            authToggleButton.topAnchor.constraint(equalTo: signInWithGoogleButton.bottomAnchor, constant: 4)
        ])
    }
}

extension AuthViewController : AuthViewModelViewDelegate {
    
    func didSucessSignInUser(user: UserAuthModel) {
        // TODO: Play animasi sambil nunggu pindah VC kalo maui
        isSignedUp = true
    }
    
    func didSucessCreateUser(user : UserAuthModel) {
        // TODO: Play animasi sambil nunggu pindah VC kalo maui
        isSignedUp = true
    }
}

