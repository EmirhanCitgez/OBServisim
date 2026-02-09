//
//  AdminHomeViewController.swift
//  OBServisim
//
//  Created by Emirhan Çitgez on 02/07/2025.
//

import UIKit
import ParseCore

class AdminHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var deviceList: [PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        // Do any additional setup after loading the view.
        fetchDevices()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceAdded(_:)),
            name: NSNotification.Name("NewDeviceAdded"),
            object: nil
        )
        
    }
    
    @objc func deviceAdded(_ notification: Notification) {
        // Yeni cihaz eklendiğinde listeyi yenile
        fetchDevices()
    }
    
    func fetchDevices() {
        let query = PFQuery(className: "Device")
        query.includeKey("customerUser")
        query.findObjectsInBackground { objects, error in
            if let devices = objects {
                self.deviceList = devices
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }else {
                print("Cihazlar alınamadı! \(error?.localizedDescription ?? "Hata")")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCardCell", for: indexPath) as? DeviceCardCell
        
        let device = deviceList[indexPath.row]
        
        cell?.deviceCardNameLabel.text = device["name"] as? String ?? "Cihaz Bilinmiyor"
        cell?.deviceCardProblemLabel.text = device["problem"] as? String ?? "Problem Bilinmiyor"
        cell?.deviceCardStatusLabel.text = device["status"] as? String ?? "Durum Bilinmiyor"
        cell?.deliveryDateCardLabel.text = "Tahmini Teslim: \(device["deliverDate"] as? String ?? "Teslim Tarihi Bilinmiyor")"
        
        // Müşteri bilgilerini göster
        if let customer = device["customerUser"] as? PFUser {
            cell?.customerCardNameLabel.text = customer.username ?? "Müşteri Bilinmiyor"
            cell?.customerCardPhoneLabel.text = customer["phone"] as? String ?? "Telefon Bilinmiyor"
        }
        
        return cell!
    }
    
    // ✅ Memory leak önlemek için
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension AdminHomeViewController: UICollectionViewDelegateFlowLayout {
    // Hücre boyutu
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            // CollectionView'in toplam genişliği
            let totalWidth = collectionView.bounds.width

            // Soldan ve sağdan eşit boşluk (toplam 52 olacak)
            let horizontalPadding: CGFloat = 26

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
