//
//  DoubleSliderUpdateFunctions.swift
//  DoubleSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit

// MARK: General update functions

extension DoubleSlider {
    
    open func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true) // Prevents interaction while updating
        
        //TODO: simplify below into helper methods / closures
        // Update lower values
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        var lowerX = lowerThumbCenter - thumbWidth / 2.0
        
        if !smoothStepping && numberOfSteps > 0 { //TODO: make this extension or helper method
            lowerX = CGFloat(roundf(Float(lowerX / stepDistance))) * stepDistance
        }
        
        lowerThumbLayer.frame = CGRect(x: lowerX, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        // Update upper values
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        var upperX = upperThumbCenter - thumbWidth / 2.0

        if !smoothStepping && numberOfSteps > 0 {
            upperX = CGFloat(roundf(Float(upperX / stepDistance))) * stepDistance
        }
        
        upperThumbLayer.frame = CGRect(x: upperX, y: 0.0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        trackLayer.frame = bounds.insetBy(dx: layerInset, dy: bounds.height / 2.15) //TODO: may be incorrect
        trackLayer.setNeedsDisplay()
        
        updateLabelPositions()
        updateLabelValues()
        minLabel.alignmentMode = kCAAlignmentCenter
        maxLabel.alignmentMode = kCAAlignmentCenter

        CATransaction.commit()
    }
    
    //TODO: simplify with more constants
    public func positionForValue(value: Double) -> Double {
        let widthDifference = Double(bounds.width - thumbWidth)
        return widthDifference * (value - minValue) / (maxValue - minValue) + Double(thumbWidth / 2.0)
    }
    
    private var stepDistance: CGFloat {
        guard numberOfSteps > 0 else {
            return 0.0
        }
        
        let distance = maxValue / Double(numberOfSteps)
        return bounds.width * CGFloat(distance)
    }
}

// MARK: Label related funcs

extension DoubleSlider {
    
    // If a custom label is set for the lower or upper value,
    // then that label is used instead of the raw value
    private func updateLabelValues() {
        if let currentStep = currentStep(for: lowerValue),
            let label = labelDelegate?.labelForStep(at: currentStep) {
            minLabel.string = label.asAttributedString
        
        } else {
            minLabel.string = lowerValue.asRoundedAttributedString
        }
        
        if let currentStep = currentStep(for: upperValue),
            let label = labelDelegate?.labelForStep(at: currentStep) {
            maxLabel.string = label.asAttributedString
            
        } else {
            maxLabel.string = upperValue.asRoundedAttributedString
        }
        setNeedsLayout()
    }
    
    private func currentStep(for value: Double) -> Int? {
        guard numberOfSteps > 0 else { return nil }
        
        return Int(round((value - minValue) * Double(numberOfSteps - 1)))
    }
    
    private func labelCenter(for label: DoubleSliderThumbLayer) -> CGPoint {
        let labelY = trackLayer.frame.midY - (minLabel.frame.height / 2.0) - spaceBetweenThumbAndLabel
        return CGPoint(x: label.frame.midX, y: labelY)
    }
    
    // TODO: split into smaller funcs
    private func updateLabelPositions() {
        let labelSize = CGSize(width: 55, height: 20)
        minLabel.frame.size = labelSize
        maxLabel.frame.size = labelSize
        
        let newMinLabelCenter = labelCenter(for: lowerThumbLayer)
        let newMaxLabelCenter = labelCenter(for: upperThumbLayer)
        
        let newRightmostXInMinLabel = newMinLabelCenter.x + minLabel.frame.width / 2.0
        let newLeftmostXInMaxLabel = newMaxLabelCenter.x - maxLabel.frame.width / 2.0
        let newSpaceBetweenLabels = newLeftmostXInMaxLabel - newRightmostXInMinLabel
        
        if newSpaceBetweenLabels > minimumSpaceBetweenLabels {
            minLabel.position = newMinLabelCenter
            maxLabel.position = newMaxLabelCenter
            
            if minLabel.frame.minX < 0.0 {
                minLabel.frame.origin.x = minLabel.frame.minX + 4.0
            }
            
            if maxLabel.frame.maxX > frame.width {
                maxLabel.frame.origin.x = frame.width - maxLabel.frame.width - 4.0
            }
            
        } else {
            let increaseAmount: CGFloat = minimumSpaceBetweenLabels - newSpaceBetweenLabels
            minLabel.position = CGPoint(x: newMinLabelCenter.x - increaseAmount / 2.0, y: newMinLabelCenter.y)
            maxLabel.position = CGPoint(x: newMaxLabelCenter.x + increaseAmount / 2.0, y: newMaxLabelCenter.y)
            
            // Update x if still in the original position
            if minLabel.position.x == maxLabel.position.x {
                minLabel.position.x = lowerThumbLayer.frame.midX
                maxLabel.position.x = lowerThumbLayer.frame.midX + minLabel.frame.width / 2.0 + minimumSpaceBetweenLabels + maxLabel.frame.width / 2.0
            }
            
            if minLabel.frame.minX < 0.0 {
                minLabel.frame.origin.x = 0.0
                maxLabel.frame.origin.x = minimumSpaceBetweenLabels + minLabel.frame.width
            }
            
            if maxLabel.frame.maxX > frame.width {
                maxLabel.frame.origin.x = frame.width - maxLabel.frame.width
                minLabel.frame.origin.x = maxLabel.frame.origin.x - minimumSpaceBetweenLabels - minimumSpaceBetweenLabels - minLabel.frame.width
            }
        }
    }
}
