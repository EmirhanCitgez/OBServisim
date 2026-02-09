//
//  DeviceCardCollectionViewCell.swift
//  OBServisim
//
//  Created by Emirhan Çitgez on 02/07/2025.
//

import UIKit

class DeviceCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var DeviceNameLabel: UILabel!
    @IBOutlet weak var DeviceDescLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var LastDateLabel: UILabel!
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
        cardView.layer.shadowColor = UIColor.systemOrange.cgColor
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
