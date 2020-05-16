//
//  UIView+ExtentionShadows.swift
//  Designables
//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import AppConstants

public extension UIView {

    struct Shadows {
        private init() { }
        public static func offsetWith(k: CGFloat) -> CGSize {
            return CGSize(width: offset.width / k, height: offset.height / k)
        }
        static var k = 1.0
        public static let offset = CGSize(width: 1, height: 5) // Shadow bellow
        public static var shadowColor = UIColor(red: CGFloat(80/255.0), green: CGFloat(88/255.0), blue: CGFloat(93/255.0), alpha: 1)
    }

    func addShadow(color: UIColor = Shadows.shadowColor,
                   offset: CGSize = Shadows.offset,
                   radius: CGFloat = Shadows.offset.height,
                   shadowType: ShadowType = ShadowType.regular) {
        self.layer.shadowColor   = color.cgColor
        self.layer.shadowOpacity = Float(1 - shadowType.rawValue)
        self.layer.shadowOffset  = offset
        self.layer.shadowRadius  = radius
        self.layer.masksToBounds = false
    }

    func addCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
