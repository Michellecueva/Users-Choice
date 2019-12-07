//
//  SettingsVC.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/5/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    var accountType = "ticketmaster" {
        didSet {
            setSelectedRowOnPicker(accountType: accountType)
        }
    }
    
    lazy var selectAPILabel: UILabel = {
        let label = UILabel()
        label.text = "Select an API to use for this account"
        label.textAlignment = .center
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
                selectAPILabel,
                APIPicker
            ]
        )
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        setSubviews()
        setConstraints()
        APIPicker.delegate = self
        getAccountType()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.xmark"), style: .done, target: self, action: #selector(signOutButton))
    }
    
    @objc func signOutButton() {
           FirebaseAuthService.manager.signOutUser()
           
           guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               
               let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window else {return}
           
           window.rootViewController = SignInVC()
       }
    
    
     //MARK: Private methods
    
    private func setSelectedRowOnPicker(accountType: String) {
        let row = accountType == APINames.ticketmaster.rawValue ? 0: 1
        APIPicker.selectRow(row, inComponent: 0, animated: true)
    }
    
    
    private func getAccountType() {
        FirestoreService.manager.getAccountType() { [weak self] (result) in
            switch result {
            case .success(let typeFromDatabase):
                self!.accountType = typeFromDatabase as! String
            case .failure(let error):
                print(error)
            }
        }
    }
    
      //MARK: UI Setup
    
    private func setSubviews() {
        self.view.addSubview(stackView)
    }
    
    private func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
            stackView.heightAnchor.constraint(equalToConstant: 250),
            stackView.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
}

extension SettingsVC: UIPickerViewDataSource, UIPickerViewDelegate {
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        FirestoreService.manager.updateAccountType(accountType: accountType) { (result) in
            switch result {
            case .success():
                print("updated account type")
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
