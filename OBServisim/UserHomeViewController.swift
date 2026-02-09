//
//  UserHomeViewController.swift
//  OBServisim
//
//  Created by Emirhan Çitgez on 29/06/2025.
//

import UIKit
import ParseCore

class UserHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var customerDevice: [PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showSuccessMessage), name: NSNotification.Name("SignUpSuccess"), object: nil)
        // Do any additional setup after loading the view.
        
        fetchDevice()
    }
    
    func fetchDevice() {
        guard let currentUser = PFUser.current() else {return}
        
        let query = PFQuery(className: "Device")
        query.whereKey("customerUser", equalTo: currentUser)
        
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                print("Cihazlar alınamadı. \(error.localizedDescription)")
            }else if let device = objects {
                self.customerDevice = device
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customerDevice.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let device = customerDevice[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCollectionViewCell", for: indexPath) as! DeviceCardCollectionViewCell
        
        cell.DeviceNameLabel.text = device["name"] as? String ?? "Cihaz Bilinmiyor"
        cell.DeviceDescLabel.text = device["problem"] as? String ?? "Problem Bilinmiyor"
        cell.statusLabel.text = device["status"] as? String ?? "Durum Bilinmiyor"
        cell.LastDateLabel.text = "Tahmini Teslim: \(device["deliverDate"] as? String ?? "Teslim Tarihi Bilinmiyor")"
        
        return cell
    }
    
    @objc func showSuccessMessage() {
        let alert = UIAlertController(title: "Merhaba!", message: "Kaydınız başarıyla oluşturuldu. OBServisim uygulamamıza hoş geldiniz.", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    


}

extension UserHomeViewController: UICollectionViewDelegateFlowLayout {
    // Hücre boyutu
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            // CollectionView'in toplam genişliği
            let totalWidth = collectionView.bounds.width

            // Soldan ve sağdan eşit boşluk (toplam 52 olacak)
            let horizontalPadding: CGFloat = 24

            // Hücrenin genişliğini padding'i düşerek hesaplıyoruz
            let cellWidth = totalWidth - (horizontalPadding * 2)
            
            return CGSize(width: cellWidth, height: 170)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            // Hem sağdan hem soldan eşit boşluk
            return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 16
        }
}
