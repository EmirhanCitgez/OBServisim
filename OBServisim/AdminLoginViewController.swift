//
//  AdminLoginViewController.swift
//  OBServisim
//
//  Created by Emirhan Çitgez on 27/06/2025.
//

import UIKit
import ParseCore

class AdminLoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var ViewCard: UIView!
    @IBOutlet weak var eyeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        
        self.navigationController?.navigationBar.tintColor = .systemOrange
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
    
    @IBAction func SignInButton(_ sender: Any) {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            self.showAlert(title: "Uyarı!", message: "Kullanıcı adı boş bırakılamaz.")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.showAlert(title: "Uyarı!", message: "Şifre alanı boş bırakılamaz.")
            return
        }
        
        PFUser.logInWithUsername(inBackground: userName, password: password) { user, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("hatalı \(error.localizedDescription)")
                    self.showAlert(title: "Hata!", message: "Kullanıcı adı veya şifre hatalı!")
                    return
                }else if let currentUser = user {
                    print("Giriş Başarılı: \(currentUser)")
                    self.performSegue(withIdentifier: "toTabBarAdmin", sender: nil)
                }
            }
        }
        
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }

}
