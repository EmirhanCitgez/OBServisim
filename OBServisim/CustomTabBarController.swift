//
//  CustomTabBarController.swift
//  OBServisim
//
//  Created by Emirhan Çitgez on 05/07/2025.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTabBarAppearance()
    }

    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6

        // Rounded top corners
        let radius: CGFloat = 20
        let bounds = tabBar.bounds
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(
            roundedRect: CGRect(x: bounds.minX, y: bounds.minY - 10, width: bounds.width, height: bounds.height + 20),
            cornerRadius: radius
        ).cgPath
        shapeLayer.fillColor = UIColor.systemGray6.cgColor
        shapeLayer.shadowColor = UIColor.systemBlue.cgColor
        shapeLayer.shadowOpacity = 0.15
        shapeLayer.shadowOffset = CGSize(width: 0, height: -2)
        shapeLayer.shadowRadius = 10

        if let oldLayer = tabBar.layer.sublayers?.first(where: { $0.name == "CustomTabBarLayer" }) {
            oldLayer.removeFromSuperlayer()
        }
        shapeLayer.name = "CustomTabBarLayer"
        tabBar.layer.insertSublayer(shapeLayer, at: 0)

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.layer.masksToBounds = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customizeTabBarAppearance()
    }

}
