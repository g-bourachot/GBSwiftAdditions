//
//  UIFontAdditions.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension UIFont {
    public func systemFontItalic(of weight: UIFont.Weight) -> UIFont? {
        var fnt = UIFont.systemFont(ofSize: self.pointSize, weight: weight)
        if let dsc = fnt.fontDescriptor.withSymbolicTraits(.traitItalic) {
            fnt = UIFont(descriptor: dsc, size: 0)
        }
        return fnt
    }

    public func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont? {
        guard let descriptorL = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        else{
            return nil
        }
        return UIFont(descriptor: descriptorL, size: 0)
    }

    public func bold() -> UIFont? {
        return withTraits(traits: .traitBold)
    }

    public func italic() -> UIFont? {
        return withTraits(traits: .traitItalic)
    }
}
#endif

