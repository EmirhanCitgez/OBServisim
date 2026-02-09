//
//  UserSignUpViewController.swift
//  OBServisim
//
//  Created by Emirhan Çitgez on 28/06/2025.
//

import UIKit
import ParseCore

class UserSignUpViewController: UIViewController {
    
    var isChecked = false
    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var ViewCard: UIView!
    
    
    @IBOutlet weak var kvkkLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = false

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
    
    @IBAction func eyeButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        
        let iconUpdate = passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        eyeButton.setImage(UIImage(systemName: iconUpdate), for: UIControl.State.normal)
    }
    
    @IBAction func checkButton(_ sender: Any) {
        isChecked.toggle()
        
        let checkUpdate = isChecked ? "checkmark.circle.fill" : "circle"
        checkButton.setImage(UIImage(systemName: checkUpdate), for: UIControl.State.normal)
        
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        guard let userName = UserNameTextField.text, !userName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Uyarı!", message: "Lütfen boş alanları doldurunuz!")
            return
        }
        
        guard isChecked else {
            showAlert(title: "Uyarı!", message: "Lütfen kullanıcı sözleşmesini onaylayınız!")
            return
        }
        
        let user = PFUser()
        user.username = userName
        user.email = email
        user.password = password
        user["phone"] = phone
        
        let acl = PFACL()
        acl.hasPublicReadAccess = true
        user.acl = acl
        
        user.signUpInBackground { success, error in
            if error != nil {
                self.showAlert(title: "Hata", message: error?.localizedDescription ?? "Error!")
            }else {
                NotificationCenter.default.post(name: NSNotification.Name("SignUpSuccess"), object: nil)
                self.performSegue(withIdentifier: "toTabBarHome", sender: nil)
            }
            
        }
        
    }
    
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    
}
