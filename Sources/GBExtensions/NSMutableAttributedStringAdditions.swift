//
//  NSMutableAttributedStringAdditions.swift
//
//
//  Created by Guillaume Bourachot on 29/10/2019.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension NSMutableAttributedString {
    
    @discardableResult public func bold(_ text: String, size: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
        let customFont = UIFont.systemFont(ofSize: size, weight: .bold)
        let attrs: [NSAttributedString.Key: Any] = [.font: customFont]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        if let color = color {
            boldString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location:0,length:text.count))
        }
        append(boldString)
        return self
    }

    @discardableResult public func black(_ text: String, size: CGFloat = 17, color: UIColor? = nil) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .black)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        if let color = color {
            boldString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location:0,length:text.count))
        }
        append(boldString)
        return self
    }
    
    @discardableResult public func normal(_ text: String, size: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
        let customFont = UIFont.systemFont(ofSize: size, weight: .regular)
        let attrs: [NSAttributedString.Key: Any] = [.font: customFont]
        let normalString = NSMutableAttributedString(string: text, attributes: attrs)
        if let color = color {
            normalString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location:0,length:text.count))
        }
        append(normalString)
        
        return self
    }

    @discardableResult public func customFont(_ text: String, FontName: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name:FontName, size:size) ?? UIFont.systemFont(ofSize: size, weight: .regular)]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)
        return self
    }
    
    @discardableResult public func customSystemFont(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: weight), .foregroundColor: color]
        let styledString = NSMutableAttributedString(string: text, attributes: attrs)
        append(styledString)        
        return self
    }

    @discardableResult public func underlined(_ text: String, color: UIColor = .black) -> NSMutableAttributedString {
        let normal = NSMutableAttributedString(string: text)
        let textRange = NSMakeRange(0, text.count)
        normal.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        normal.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: textRange)
        append(normal)
        return self
    }

    @discardableResult public func strikeThrough(_ text: String, color: UIColor = .black) -> NSMutableAttributedString {
        let normal = NSMutableAttributedString(string: text)
        let textRange = NSMakeRange(0, text.count)
        normal.addAttribute(NSAttributedString.Key.strikethroughStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        normal.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: textRange)
        append(normal)
        return self
    }

    @discardableResult public func colored(_ text: String, color: UIColor) -> NSMutableAttributedString {
        let normal = NSMutableAttributedString(string: text)
        let textRange = NSMakeRange(0, text.count)
        normal.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: textRange)
        append(normal)
        return self
    }
}

#endif
