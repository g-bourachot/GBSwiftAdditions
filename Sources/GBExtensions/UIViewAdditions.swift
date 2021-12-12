//
//  UIViewAdditions.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension UIView {
    public func setRoundedCorner(for corners: UIRectCorner, with radius: CGFloat) {
        if #available(iOS 11.0, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var maskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
            if !corners.contains(.topLeft) { maskedCorners.remove(.layerMinXMinYCorner) }
            if !corners.contains(.topRight) { maskedCorners.remove(.layerMaxXMinYCorner) }
            if !corners.contains(.bottomLeft) { maskedCorners.remove(.layerMinXMaxYCorner) }
            if !corners.contains(.bottomRight) { maskedCorners.remove(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = maskedCorners
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }

    public func setRoundedBorder(radius: CGFloat, borderWidth: CGFloat, color: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
}
#endif
