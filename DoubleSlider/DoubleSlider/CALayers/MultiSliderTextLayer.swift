//
//  DoubleSliderTextLayer.swift
//  DoubleSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import QuartzCore

public class DoubleSliderTextLayer: CATextLayer, DoubleSliderLayer {
    weak var doubleSlider: DoubleSlider?
    
//    // For adding label background
//    public override func draw(in ctx: CGContext) {
//        guard let slider = doubleSlider else { return }
//
//        let cornerRadius = bounds.height * slider.roundedness / 2.0
//        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//
//        ctx.setFillColor(UIColor.black.cgColor) //TODO: make color customizable
//        ctx.addPath(path.cgPath)
//        ctx.fillPath()
//    }
}
