//
//  SignUpVC.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


enum APINames: String {
    case ticketmaster
    case rijksmuseum
}

class SignUpVC: UIViewController {
    
    var accountType = "ticketmaster"
    
    lazy var titleLabel: UILabel = {
           let label = UILabel()
           label.numberOfLines = 0
           label.text = "Pursuitstgram: Create Account"
           label.font = UIFont(name: "Arial", size: 28)
           label.textColor = .white
           label.backgroundColor = .clear
           label.textAlignment = .center
           return label
       }()
       
       lazy var emailTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Enter Email"
           textField.font = UIFont(name: "Verdana", size: 14)
           textField.backgroundColor = .lightText
           textField.borderStyle = .roundedRect
           textField.autocorrectionType = .no
           return textField
       }()
       
       lazy var passwordTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Enter Password"
           textField.font = UIFont(name: "Verdana", size: 14)
           textField.backgroundColor = .lightText
           textField.borderStyle = .roundedRect
           textField.autocorrectionType = .no
           textField.isSecureTextEntry = true
           return textField
       }()
       
       lazy var createButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Create", for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
           button.backgroundColor = #colorLiteral(red: 0.1345793307, green: 0.03780555353, blue: 0.9968826175, alpha: 1)
           button.layer.cornerRadius = 5
           button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
           button.isEnabled = true
           return button
       }()
    
    lazy var selectAPILabel: UILabel = {
        let label = UILabel()
        label.text = "Select and API to use for this account"
        label.textColor = .white
        return label
    }()
    
    lazy var APIPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.sizeToFit()
        return pickerView
    }()
       
       lazy var stackView: UIStackView = {
           let stackView = UIStackView(
               arrangedSubviews: [
                   emailTextField,
                   passwordTextField,
               ]
           )
           stackView.axis = .vertical
           stackView.spacing = 15
           stackView.distribution = .fillEqually
           return stackView
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        APIPicker.delegate = self
        APIPicker.dataSource = self
        setSubviews()
        setConstraints()
    }
    
    //MARK: Obj-C Methods
       
       
       @objc func trySignUp() {
           if !validateFields() {
               return
           }
           
           let email = emailTextField.text!
           let password = passwordTextField.text!
           FirebaseAuthService.manager.createNewUser(email: email, password:password) { [weak self] (result) in
               self?.handleCreateAccountResponse(result: result)
           }
       }
       
       
       //MARK: Private methods
       
       private func showErrorAlert(title: String, message: String) {
           let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
           present(alertVC, animated: true, completion: nil)
       }
       
       private func validateFields() -> Bool {
           guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
               showErrorAlert(title: "Error", message: "Please fill out all fields.")
               return false
           }
           
           guard email.isValidEmail else {
               showErrorAlert(title: "Error", message: "Please enter a valid email")
               return false
           }
           
           guard password.isValidPassword else {
               showErrorAlert(title: "Error", message: "Please enter a valid password. Passwords must have at least 8 characters.")
               return false
           }
           
           return true
       }
       
       private func handleCreateAccountResponse(result: Result<User, Error>) {
           DispatchQueue.main.async { [weak self] in
               switch result {
               case .success(let user):
                
                FirestoreService.manager.createAppUser(user: AppUser(from: user, accountType: self?.accountType)) { [weak self] (result) in
                       self?.handleCreatedUserInFirestoreResponse(result: result)
                   }
               case .failure(let error):
                   self?.showErrorAlert(title: "Error creating user", message: error.localizedDescription)
               }
           }
       }
       
       private func handleCreatedUserInFirestoreResponse(result: Result<(), Error>) {
           switch result {
           case .failure(let error):
               showErrorAlert(title: "Error", message: "Could not log in. Error \(error)")
           case .success:
               guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               
                   let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window else {return}
               
               UIView.transition(with: window, duration: 0.3, options: .curveLinear, animations: {
                   window.rootViewController = TabBarVC()
               }, completion: nil)
           }
       }
       
 
    
    //MARK: UI Setup
         
         private func setSubviews() {
             self.view.addSubview(titleLabel)
             self.view.addSubview(stackView)
           self.view.addSubview(selectAPILabel)
             self.view.addSubview(APIPicker)
            self.view.addSubview(createButton)
         }
    
    private func setConstraints() {
               setTitleLabelConstraints()
               setupStackViewConstraints()
               setAPILabelConstraints()
               setPickerConstraints()
               setCreateAccountButtonConstraints()
           }
    
     private func setTitleLabelConstraints() {
           
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
               titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
               titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
               titleLabel.heightAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8)])
       }
    
    private func setupStackViewConstraints() {
           
           stackView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
               stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
               stackView.heightAnchor.constraint(equalToConstant: 100)
           ])
       }
    
    private func setAPILabelConstraints() {
        selectAPILabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectAPILabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            selectAPILabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
        
         
    }
    
    private func setPickerConstraints() {
        APIPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            APIPicker.topAnchor.constraint(equalTo: selectAPILabel.bottomAnchor),
            APIPicker.centerXAnchor.constraint(equalTo: selectAPILabel.centerXAnchor),
            APIPicker.heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
    private func setCreateAccountButtonConstraints() {
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: APIPicker.bottomAnchor, constant: 30),
            createButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            createButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
}

extension SignUpVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            accountType = APINames.ticketmaster.rawValue
        default:
            accountType = APINames.rijksmuseum.rawValue
        }
        return accountType
    }
    
}
