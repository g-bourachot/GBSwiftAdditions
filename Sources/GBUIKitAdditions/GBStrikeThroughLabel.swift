//
//  GBStrikeThroughLabel.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if os(iOS)
import UIKit
public class GBStrikeThroughLabel: UILabel {

    override public var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            self.attributedText = attributedText
        }
    }
}
#endif
