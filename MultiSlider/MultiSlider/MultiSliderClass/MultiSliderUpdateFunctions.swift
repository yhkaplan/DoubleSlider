//
//  MultiSliderUpdateFunctions.swift
//  MultiSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit

extension MultiSlider {
    
    open func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true) // Prevents interaction while updating
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 2.15) //TODO: may be incorrect
        trackLayer.setNeedsDisplay()
        
        //TODO: simplify below into helper methods / closures
        // Update lower values
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        var lowerX = lowerThumbCenter - thumbWidth / 2.0
        
        if let stepDistance = stepDistance, stepDistance > 0.0 { //TODO: make this extension or helper method
            lowerX = CGFloat(roundf(Float(lowerX / stepDistance))) * stepDistance
        }
        
        lowerThumbLayer.frame = CGRect(x: lowerX, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        // Update upper values
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        var upperX = upperThumbCenter - thumbWidth / 2.0
        
        if let stepDistance = stepDistance, stepDistance > 0.0 {
            upperX = CGFloat(roundf(Float(upperX / stepDistance))) * stepDistance
        }
        
        upperThumbLayer.frame = CGRect(x: upperX, y: 0.0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        updateLabelPositions()
        updateLabelValues()
        
        CATransaction.commit()
    }
    
    //TODO: simplify with more constants
    public func positionForValue(value: Double) -> Double {
        let widthDifference = Double(bounds.width - thumbWidth)
        return widthDifference * (value - minValue) / (maxValue - minValue) + Double(thumbWidth / 2.0)
    }
    // MARK: Label related funcs TODO: move to extension in separate file
    private func updateLabelValues() {
        minLabel.string = NumberFormatter().string(from: minValue as NSNumber)
        maxLabel.string = NumberFormatter().string(from: maxValue as NSNumber)
        
        setNeedsLayout()
    }
    
    private func updateLabelPositions() {
        let labelSize = CGSize(width: 16, height: 8)
        minLabel.frame.size = labelSize
        maxLabel.frame.size = labelSize
        
        let minimumSpaceBetweenLabels: CGFloat = 8.0
        let spaceBetweenThumbAndLabel: CGFloat = 8.0
        
        let newMinY = lowerThumbLayer.frame.midY - (minLabel.frame.height / 2.0) - spaceBetweenThumbAndLabel
        let newMinLabelCenter = CGPoint(x: lowerThumbLayer.frame.midX, y: newMinY)
        
        let newMaxY = upperThumbLayer.frame.midY - (maxLabel.frame.height / 2.0) - spaceBetweenThumbAndLabel
        let newMaxLabelCenter = CGPoint(x: upperThumbLayer.frame.midX, y: newMaxY)
        
        let newRightmostXInMinLabel = newMinLabelCenter.x + minLabel.frame.width / 2.0
        let newLeftmostXInMaxLabel = newMaxLabelCenter.x - maxLabel.frame.width / 2.0
        let newSpaceBetweenLabels = newLeftmostXInMaxLabel - newRightmostXInMinLabel
        
        if newSpaceBetweenLabels > minimumSpaceBetweenLabels {
            minLabel.position = newMinLabelCenter
            maxLabel.position = newMaxLabelCenter
            
            if minLabel.frame.minX < 0.0 {
                minLabel.frame.origin.x = 0.0
            }
            
            if maxLabel.frame.maxX > frame.width {
                maxLabel.frame.origin.x = frame.width - maxLabel.frame.width
            }
        } else {} //TODO: see585
    }
}

