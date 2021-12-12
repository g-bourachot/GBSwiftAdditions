//
//  GBGradientBackgroundView.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if os(iOS)
import UIKit

@IBDesignable public class GBGradientBackgroundView: UIView {
    
    @IBInspectable public var startColor: UIColor = .black { didSet { updateColors() }}
    @IBInspectable public var endColor: UIColor = .white { didSet { updateColors() }}
    @IBInspectable public var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable public var endLocation: Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable public var horizontalMode: Bool =  false { didSet { updatePoints() }}
    @IBInspectable public var diagonalMode: Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { return CAGradientLayer.self }
    
    public var gradientLayer: CAGradientLayer {
        guard let layer = layer as? CAGradientLayer else {
            fatalError("couldn't convert layer to a CAGradientLayer")
        }
        return layer
    }
    
    public func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    public func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    public func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}
#endif

