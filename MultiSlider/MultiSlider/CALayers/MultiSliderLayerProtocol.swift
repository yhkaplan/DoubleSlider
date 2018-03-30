//
//  MultiSliderLayerProtocol.swift
//  MultiSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

// This is the protocol that all CALayer/CATextLayer components
// used by MultiSlider. It ensures they contain a weak delegate
// to MultiSlider
// Swift bug report about this error message: https://bugs.swift.org/browse/SR-6265
protocol MultiSliderLayer: class where Self: CALayer  {
    weak var multiSlider: MultiSlider? { get set }
}
