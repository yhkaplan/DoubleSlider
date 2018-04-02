//
//  Extensions.swift
//  DoubleSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

extension Array {
    func item(at index: Int) -> Array.Element? {
        return (index < self.count && index >= 0) ? self[index] : nil
    }
}
