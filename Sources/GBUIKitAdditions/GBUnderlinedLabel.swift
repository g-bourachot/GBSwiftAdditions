//
//  GBUnderlinedLabel.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if os(iOS)
import UIKit
public class GBUnderlinedLabel: UILabel {    
    @IBInspectable public var underlinedTitle: String? {
        didSet {
            guard let text = underlinedTitle else { return }
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
            self.attributedText = attributedText
            self.setNeedsDisplay()
        }
    }
    
    override public var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
#endif
