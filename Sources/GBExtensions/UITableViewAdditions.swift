//
//  UITableViewAdditions.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension UITableView {
    
    public func registerCells<T: UITableViewCell>(cells: [T]){
        for cell:T in cells
        {
            let cellName = String(describing: type(of: cell))
            self.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        }
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(for indexPath:IndexPath, withIdentifier cellName:String = String(describing: type(of: T.self))) -> T {
        guard let cell:T = self.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? T else {
                fatalError("Couldn't convert dequeueReusableCell into \(cellName)")
        }
        return cell
    }
}

#endif

