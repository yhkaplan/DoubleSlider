//
//  Extensions.swift
//  DoubleSlider
//
//  Created by josh on 2018/04/02.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import Foundation

extension Double {
    
    // Rounds double to two decimal places
    var roundedToTwoPlaces: Double {
        let divisor = pow(10.0, 2.0)
        return (self * divisor).rounded() / divisor
    }
    
    // This is used to provide a formatted version of the label
    // string for the current upper/lower value
    var asRoundedAttributedString: NSAttributedString {
        return "\(self.roundedToTwoPlaces)".asAttributedString
    }
    
}

extension String {
    
    var asAttributedString: NSAttributedString {
        return NSAttributedString(string: self, attributes: DoubleSlider.labelAttributes)
    }
    
}
