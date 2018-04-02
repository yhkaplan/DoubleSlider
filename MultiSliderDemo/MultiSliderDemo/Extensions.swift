//
//  Extensions.swift
//  MultiSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

extension Array {
    func item(at index: Int) -> Array.Element? {
        return index < self.count ? self[index] : nil
    }
}
