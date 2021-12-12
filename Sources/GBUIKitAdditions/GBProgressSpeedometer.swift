//
//  GBProgressSpeedometer.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if os(iOS)
import UIKit

@IBDesignable public class GBProgressSpeedometer: UIView {
    
    // MARK: - Variables
    @IBInspectable public var progressColor: UIColor = UIColor.green
    @IBInspectable public var progressWidth: CGFloat = 1.0
    @IBInspectable public var trackColor: UIColor = UIColor.gray
    @IBInspectable public var trackWidth: CGFloat = 1.0
    
    public var progress: Float = 0.5 {
        didSet(newValue) {
            self.refreshUI()
        }
    }
    private var progressLayer: CAShapeLayer!
    private var backgroundLayer: CAShapeLayer!
    private var gradientLayer: CAGradientLayer {
        guard let layer = layer as? CAGradientLayer else {
            fatalError("couldn't convert layer to a CAGradientLayer")
        }
        return layer
    }
    
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
    public func configure(trackColor: UIColor, progressColor: UIColor, progress: Float) {
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.progress = progress
        self.refreshUI()
        self.setNeedsLayout()
    }
    
    private func setUp() {
        let arcCenter   = CGPoint(x: (self.bounds.midX), y: (self.bounds.midY))
        let radius      = Float(min((self.bounds.midX) - 1, (self.bounds.midY)-1))
        let startAngle = CGFloat(Int(140)) * .pi / 180
        let endAngle = CGFloat(Int(400)) * .pi / 180
        let circlePath: UIBezierPath = UIBezierPath(arcCenter: arcCenter, radius:
            CGFloat(radius), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        self.backgroundColor = UIColor.clear
        self.backgroundLayer = CAShapeLayer()
        self.backgroundLayer.path = circlePath.cgPath
        self.backgroundLayer.strokeColor = self.trackColor.cgColor
        self.backgroundLayer.fillColor = UIColor.clear.cgColor
        self.backgroundLayer.lineWidth = self.trackWidth
        
        self.progressLayer = CAShapeLayer()
        self.progressLayer.frame = self.bounds
        self.progressLayer.path = circlePath.cgPath
        self.progressLayer.lineWidth = self.progressWidth
        self.progressLayer.strokeColor = self.progressColor.cgColor
        self.progressLayer.fillColor = nil
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = 0.0
        self.progressLayer.lineCap = .round
        
        self.layer.addSublayer(backgroundLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    private func refreshUI() {
        self.backgroundLayer.strokeColor = self.trackColor.cgColor
        self.backgroundLayer.lineWidth = self.trackWidth
        self.progressLayer.strokeColor = self.progressColor.cgColor
        self.progressLayer.lineWidth = self.progressWidth
        self.progressLayer.strokeEnd = CGFloat(self.progress)
    }
    
    // MARK: - Layout
    override public func layoutSubviews() {
        self.refreshUI()
    }
}
#endif

