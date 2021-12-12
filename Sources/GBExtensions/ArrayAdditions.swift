//
//  ArrayAdditions.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation

extension Array {
    public func chunked(by distance: Int) -> [[Element]] {
        if self.count <= distance {
            return [self]
        } else {
            let head = [Array(self[0 ..< distance])]
            let tail = Array(self[distance ..< self.count])
            return head + tail.chunked(by: distance)
        }
    }
}
