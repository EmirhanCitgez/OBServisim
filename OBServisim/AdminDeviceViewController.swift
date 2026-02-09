//
//  AdminDeviceViewController.swift
//  OBServisim
//
//  Created by Emirhan Çitgez on 02/07/2025.
//

import UIKit
import ParseCore

class AdminDeviceViewController: UIViewController {
    
    @IBOutlet weak var deviceNameTextField: UITextField!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var customerTableView: UITableView!
    @IBOutlet weak var deviceProblemTextField: UITextField!
    @IBOutlet weak var deviceStatus: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    
    var allCustomers: [PFUser] = []
    var filteredCustomers: [PFUser] = []
    var selectedCustomer: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerTableView.delegate = self
        customerTableView.dataSource = self
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue
        ]

        deviceStatus.setTitleTextAttributes(normalAttributes, for: .normal)
        deviceStatus.setTitleTextAttributes(selectedAttributes, for: .selected)
        deviceStatus.selectedSegmentTintColor = UIColor.systemBlue
        
        // Do any additional setup after loading the view.
        
        customerTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let query = PFUser.query()
        query?.findObjectsInBackground { userArray, error in
            if let error = error {
                print("Query hatası: \(error.localizedDescription)")
                return
            }

            guard let users = userArray as? [PFUser] else {
                print("User casting başarısız")
                return
            }

            print("Kullanıcı sayısı: \(users.count)")
            
            // HER KULLANICI İÇİN DEBUG
            for (index, user) in users.enumerated() {
                print("--- Kullanıcı \(index) ---")
                print("Username: \(user.username ?? "nil")")
                print("Phone: \(user["phone"] ?? "nil")")
                print("Tüm keys: \(user.allKeys)")
                print("---")
            }
            
            self.allCustomers = users.filter { $0["role"] as? String != "admin" }
            self.filteredCustomers = users
            
            DispatchQueue.main.async {
                self.customerTableView.reloadData()
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased() else {return}
        
        if searchText.isEmpty {
            customerTableView.isHidden = true
        } else {
            customerTableView.isHidden = false
            filteredCustomers = allCustomers.filter{
                let username = ($0.username ?? "").lowercased()
                let phone = ($0["phone"] as? String ?? "").lowercased()
                
                return username.contains(searchText) || phone.contains(searchText)
            }
            customerTableView.reloadData()
        }
    }
    

    @IBAction func saveButton(_ sender: Any) {
        guard let name = deviceNameTextField.text, !name.isEmpty,
              let problem = deviceProblemTextField.text, !problem.isEmpty,
              let date = dateTextField.text, !date.isEmpty,
              let customer = selectedCustomer else {
            makeAlert(title: "Uyarı!", message: "Lütfen tüm alanları doldurun ve müşteri seçin.")
            return
        }
        
        let device = PFObject(className: "Device")
        device["name"] = name
        device["problem"] = problem
        device["status"] = deviceStatus.titleForSegment(at: deviceStatus.selectedSegmentIndex)
        device["customerUser"] = customer
        device["deliverDate"] = date
        
        device.saveInBackground { success, error in
            if error != nil {
                self.makeAlert(title: "Hata!", message: "Cihaz kaydı başarısız!")
            }else{
                self.makeAlert(title: "Başarılı!", message: "Cihaz kaydı başarılı.")
                
                NotificationCenter.default.post(
                    name: NSNotification.Name("NewDeviceAdded"),
                    object: nil,
                    userInfo: ["customer": customer, "device": device]
                )
                
                // Ana sayfaya dön
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    
    
    
}

extension AdminDeviceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredCustomers.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = filteredCustomers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath)
        
        // Username'i göster (name yok çünkü)
        cell.textLabel?.text = user.username ?? "İsim yok"
        // Phone key'ini kullan (phoneNumber değil!)
        cell.detailTextLabel?.text = user["phone"] as? String ?? "Telefon yok"
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCustomer = filteredCustomers[indexPath.row]
        let name = selectedCustomer?.username ?? ""
        let phone = selectedCustomer?["phone"] as? String ?? ""
        customerTextField.text = "\(name) - \(phone)"
        tableView.isHidden = true
    }
}
