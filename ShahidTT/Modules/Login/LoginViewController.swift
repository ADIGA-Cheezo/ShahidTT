//
//  ViewController.swift
//  ShahidTT
//
//  Created by atsmac on 28/08/2023.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let viewModel = loginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupView()
    }
    
    private func setupView() {
        usernameTextField.addTarget(self, action: #selector(usernameTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
        setupGradient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    @objc private func usernameTextFieldChanged() {
        viewModel.username = usernameTextField.text ?? ""
        updateLoginButtonState()
    }
    
    @objc private func passwordTextFieldChanged() {
        viewModel.password = passwordTextField.text ?? ""
        updateLoginButtonState()
    }
    
    private func updateLoginButtonState() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.loginButton.isEnabled = !self.viewModel.username.isEmpty && !self.viewModel.password.isEmpty
        }
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        guard let accentColor = UIColor(named: "AccentColor")?.cgColor else { return }
        gradientLayer.colors = [UIColor.systemBackground.cgColor, accentColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        // Set the initial frame to the layer (will be updated in layoutSubviews)
        gradientLayer.frame = view.bounds
        
        // Add the gradient layer as a sublayer to the background view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        login()
    }
    
    private func login() {
        viewModel.login { success in
            if success {
//                self.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
                print("success")
            } else {
                let alert = UIAlertController(title: "Login Failed", message: "Invalid credentials.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
            login()
        }
        return true
    }
}

