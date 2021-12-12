//
//  GBResizableUISlider.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if os(iOS)
import UIKit

@IBDesignable public class GBResizableUISlider: UISlider {
    
    @IBInspectable public var backgroundTrackColor: UIColor = UIColor.blue {
        willSet(newValue) {
            self.backgroundTrackColor = newValue
            self.setUp()
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var progressTrackColor: UIColor = UIColor.green {
        willSet(newValue) {
            self.progressTrackColor = newValue
            self.setUp()
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var trackHeight: CGFloat = 1.0 {
        willSet(newValue) {
            self.trackHeight = newValue
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var indicatorColor: UIColor = UIColor.white {
        willSet(newValue) {
            self.indicatorColor = newValue
            self.setUp()
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var indicatorHeight: CGFloat = 1.0 {
        willSet(newValue) {
            self.indicatorHeight = newValue
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var changeIndicatorSize: Bool = false
    
    // MARK: - SetUp Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    // MARK: - Functions
    private func setUp() {
        self.minimumTrackTintColor = self.progressTrackColor
        self.maximumTrackTintColor = self.backgroundTrackColor
        if self.changeIndicatorSize, let thumbImage = self.circle(diameter: self.indicatorHeight, color: self.indicatorColor) {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
    
    private func circle(diameter: CGFloat, color: UIColor) -> UIImage? {
        let shadowOffset: CGFloat = 2
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: diameter+shadowOffset*2, height: diameter+shadowOffset*2), false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        ctx.saveGState()

        let shadowColor = UIColor.init(white: 0, alpha: 0.03).cgColor
        ctx.setFillColor(shadowColor)
        ctx.setStrokeColor(shadowColor)
        ctx.setLineWidth(1)
        
        let shadowRectangle = CGRect(x: 0, y: shadowOffset, width: diameter, height: diameter)
        ctx.addEllipse(in: shadowRectangle)
        ctx.drawPath(using: .fillStroke)
        
        ctx.setFillColor(color.cgColor)
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(1)

        let rectangle = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.addEllipse(in: rectangle)
        ctx.drawPath(using: .fillStroke)
        
        let borderColor = UIColor.init(white: 0, alpha: 0.15).cgColor
        ctx.setStrokeColor(borderColor)
        let strokeRectangle = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.addEllipse(in: strokeRectangle)
        ctx.drawPath(using: .stroke)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img
    }
    
    // MARK: - Overrided functions
    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = self.trackHeight
        return newBounds
    }
}
#endif

