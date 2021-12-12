//
//  GBUnderLinedButton.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if os(iOS)
import UIKit
@IBDesignable public class GBUnderLinedButton: UIButton {
    
    @IBInspectable public var underlinedTitle: String? {
        didSet {
            guard let text = underlinedTitle else { return }
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
            self.titleLabel?.attributedText = attributedText
            self.setNeedsDisplay()
        }
    }
    
}
#endif
