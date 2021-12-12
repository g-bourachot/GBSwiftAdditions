//
//  GBCopyableLabel.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if os(iOS)
import UIKit

public class GBCopyableLabel: UILabel {
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(showMenu(sender:))
        ))
    }
    
    override public func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        if #available(iOS 13.0, *) {
            UIMenuController.shared.hideMenu(from: self)
        } else {
            UIMenuController.shared.setMenuVisible(false, animated: true)
        }
    }
    
    @objc func showMenu(sender: Any?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            if #available(iOS 13.0, *) {
                menu.showMenu(from: self, rect: bounds)
            } else {
                menu.setTargetRect(bounds, in: self)
                menu.setMenuVisible(true, animated: true)

            }
        }
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(copy(_:)))
    }
}
#endif

