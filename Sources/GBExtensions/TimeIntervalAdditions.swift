//
//  TimeIntervalAdditions.swift
//
//
//  Created by Guillaume Bourachot on 29/10/2019.
//

import Foundation

extension TimeInterval {
    
    public var clockString: String {
        let timeInterval = NSInteger(self)
        let seconds = timeInterval % 60
        let minutes = (timeInterval / 60) % 60
        let hours = (timeInterval / 3600)
        if hours <= 0 && minutes <= 0 {
            return String(format: "0:%0.2d", seconds)
        }
        if hours <= 0 && minutes <= 9 {
            return String(format: "%0.1d:%0.2d", minutes, seconds)
        }
        if hours <= 0 && minutes > 9 {
            return String(format: "%0.2d:%0.2d", minutes, seconds)
        }
        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
}
