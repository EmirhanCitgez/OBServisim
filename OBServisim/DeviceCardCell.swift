//
//  DeviceCardCell.swift
//  OBServisim
//
//  Created by Emirhan Çitgez on 05/07/2025.
//

import UIKit

class DeviceCardCell: UICollectionViewCell {
    
    @IBOutlet weak var deviceCardNameLabel: UILabel!
    @IBOutlet weak var deviceCardProblemLabel: UILabel!
    @IBOutlet weak var deliveryDateCardLabel: UILabel!
    @IBOutlet weak var viewStatusCard: UIView!
    @IBOutlet weak var deviceCardStatusLabel: UILabel!
    @IBOutlet weak var customerCardNameLabel: UILabel!
    @IBOutlet weak var customerCardPhoneLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            setupCardStyle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = false
    }

    func setupCardStyle() {
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.blue.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8
        cardView.layer.masksToBounds = false
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: 16
        ).cgPath
        cardView.backgroundColor = .white
    }
    
}
