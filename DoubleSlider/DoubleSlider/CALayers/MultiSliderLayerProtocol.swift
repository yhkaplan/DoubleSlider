//
//  DoubleSliderLayerProtocol.swift
//  DoubleSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

// This is the protocol that all CALayer/CATextLayer components
// used by DoubleSlider. It ensures they contain a weak delegate
// to DoubleSlider
// Swift bug report about this error message: https://bugs.swift.org/browse/SR-6265
protocol DoubleSliderLayer: class where Self: CALayer  {
    weak var doubleSlider: DoubleSlider? { get set }
}
