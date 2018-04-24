//
//  DoubleSliderTouchTracking.swift
//  DoubleSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit

extension DoubleSlider {
    
    // MARK: - Touch tracking
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.isHighlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.isHighlighted = true
        }
        
        return lowerThumbLayer.isHighlighted || upperThumbLayer.isHighlighted
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // Check drag distance
        let dragDistance = Double(location.x - previousLocation.x)
        let dragValue = (maxValue - minValue) * dragDistance / Double(bounds.width - thumbWidth)
        
        previousLocation = location
        let minimumSpace = stepDistance ?? 0.05
        
        // Update values
        if lowerThumbLayer.isHighlighted {
            var lowerTempValue = lowerValue + dragValue
            lowerTempValue = boundValue(value: lowerTempValue, lowerValue: minValue, upperValue: upperValue)
            
            // For when steps are set without smoothStepping
            if !smoothStepping, let steppedValue = steppedValue(for: lowerTempValue) {
                lowerTempValue = steppedValue
            }
            
            let highestPositionAllowed = upperValue - minimumSpace
            
            // For when steps are set with or without smoothStepping
            if let lowerIndex = stepIndex(for: lowerTempValue),
                let upperIndex = stepIndex(for: upperValue),
                lowerIndex >= upperIndex {
                
                lowerTempValue = value(for: upperIndex - 1) ?? highestPositionAllowed
                
            // For when no steps are set
            } else if lowerTempValue > highestPositionAllowed {
                lowerTempValue = highestPositionAllowed
            }
            
            lowerValue = lowerTempValue
            
        } else if upperThumbLayer.isHighlighted {
            var upperTempValue = upperValue + dragValue
            upperTempValue = boundValue(value: upperTempValue, lowerValue: lowerValue, upperValue: maxValue)
            
            // For when steps are set without smoothStepping
            if !smoothStepping, let steppedValue = steppedValue(for: upperTempValue) {
                upperTempValue = steppedValue
            }
            
            let lowestPositionAllowed = lowerValue + minimumSpace
            
            // For when steps are set with or without smoothStepping
            if let upperIndex = stepIndex(for: upperTempValue),
                let lowerIndex = stepIndex(for: lowerValue),
                upperIndex <= lowerIndex {
                
                upperTempValue = value(for: lowerIndex + 1) ?? lowestPositionAllowed
            
            // For when no steps are set
            } else if upperTempValue < lowestPositionAllowed {
                upperTempValue = lowestPositionAllowed
            }

            upperValue = upperTempValue
        }
        
        // Declare that a value was updated, called continuously
        sendActions(for: .valueChanged)
        valueChangedDelegate?.valueChanged(for: self)
        
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
        
        // Declare that the change finished, called at the end
        // of a drag session
        sendActions(for: .editingDidEnd)
        editingDidEndDelegate?.editingDidEnd(for: self)
    }
    
    // MARK: - Private funcs
    
    private func steppedValue(for value: Double) -> Double? {
        guard let stepDistance = stepDistance else { return nil }
        
        return round(value / stepDistance) * stepDistance
    }
    
    private func boundValue(value: Double, lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
}
