//
//  Extensions.swift
//  DoubleSlider
//
//  Created by josh on 2018/04/02.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

extension Double {
    
    var roundedToTwoPlaces: Double {
        let divisor = pow(10.0, 2.0)
        return (self * divisor).rounded() / divisor
    }
    
    // This is used to provide a formatted version of the label
    // string for the current upper/lower value
    var asAttributedString: NSAttributedString {
        return "\(self.roundedToTwoPlaces)".withDefaultAttributes
    }
    
}

extension String {
    
    var withDefaultAttributes: NSAttributedString {
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: Colors.textGray
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
}
