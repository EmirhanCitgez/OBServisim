//
//  UserLoginViewController.swift
//  OBServisim
//
//  Created by Emirhan Çitgez on 27/06/2025.
//

import UIKit
import ParseCore

class UserLoginViewController: UIViewController {
    
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EyeButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var ViewCard: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PasswordTextField.isSecureTextEntry = true
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        // Do any additional setup after loading the view.
        
        viewCardSetup()
    }
    
    func viewCardSetup() {
        ViewCard.layer.cornerRadius = 26
        ViewCard.layer.shadowColor = UIColor.black.cgColor
        ViewCard.layer.shadowOpacity = 0.3
        ViewCard.layer.shadowOffset = CGSize(width: 0, height: -4)
        ViewCard.layer.shadowRadius = 5
        
    }
    
    
    @IBAction func EyeButton(_ sender: Any) {
        
        PasswordTextField.isSecureTextEntry.toggle()
        
        let updateIcon = PasswordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        EyeButton.setImage(UIImage(systemName: updateIcon), for: UIControl.State.normal)
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        guard let email = EmailTextField.text, !email.isEmpty,
              let password = PasswordTextField.text, !password.isEmpty else {
            showAlert(title: "Uyarı!", message: "Lütfen bilgilerinizi doğru ve eksiksiz girdiğinizden emin olun.")
            return
        }
        
        let user = PFUser()
        user.email = email
        user.password = password
        
        PFUser.logInWithUsername(inBackground: email, password: password) { success, error in
            if error != nil {
                self.showAlert(title: "Hata!", message: error?.localizedDescription ?? "Error!")
            }else {
                self.performSegue(withIdentifier: "toTabBarH", sender: nil)
            }
        }
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
}


