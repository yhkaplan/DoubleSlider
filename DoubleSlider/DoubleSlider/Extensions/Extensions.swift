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
}

extension String {
    var withAttributes: NSAttributedString {
        
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: Colors.textGray
        ]
        return NSAttributedString(string: self, attributes: attributes)
    }
}
