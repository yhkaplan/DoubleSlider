//
//  DoubleSliderTouchTracking.swift
//  DoubleSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit

extension DoubleSlider {
    
    // MARK: - Private var
    
    private var minimumSpaceBetweenThumbOrigins: Double {
        return stepDistance ?? 0.05
    }
    
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
        
        // Update values
        if lowerThumbLayer.isHighlighted {
            lowerValue = lowerValueAdjusted(for: dragValue)
            
        } else if upperThumbLayer.isHighlighted {
            upperValue = upperValueAdjusted(for: dragValue)
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
    
    private func lowerValueAdjusted(for dragValue: Double) -> Double {
        var lowerTempValue = lowerValue + dragValue
        lowerTempValue = boundValue(value: lowerTempValue, lowerValue: minValue, upperValue: upperValue)
        
        // For step-like behavior
        if !smoothStepping, let steppedValue = steppedValue(for: lowerTempValue) {
            lowerTempValue = steppedValue
        }
        
        let highestPositionAllowed = upperValue - minimumSpaceBetweenThumbOrigins
        
        // To prevent excessive overlap
        if lowerTempValue > highestPositionAllowed {
            lowerTempValue = highestPositionAllowed
        }
        
        // To prevent a rare case in which 2 thumbs are barely near
        // enough to register as the same stepIndex/label
        if let lowerIndex = stepIndex(for: lowerTempValue),
            let upperIndex = stepIndex(for: upperValue),
            lowerIndex >= upperIndex {
            
            lowerTempValue = lowerValue
        }
        
        return lowerTempValue
    }
    
    private func upperValueAdjusted(for dragValue: Double) -> Double {
        var upperTempValue = upperValue + dragValue
        upperTempValue = boundValue(value: upperTempValue, lowerValue: lowerValue, upperValue: maxValue)
        
        // For step-like behavior
        if !smoothStepping, let steppedValue = steppedValue(for: upperTempValue) {
            upperTempValue = steppedValue
        }
        
        let lowestPositionAllowed = lowerValue + minimumSpaceBetweenThumbOrigins
        
        // To prevent excessive overlap
        if upperTempValue < lowestPositionAllowed {
            upperTempValue = lowestPositionAllowed
        }
        
        // To prevent a rare case in which 2 thumbs are barely near
        // enough to register as the same stepIndex/label
        if let upperIndex = stepIndex(for: upperTempValue),
            let lowerIndex = stepIndex(for: lowerValue),
            upperIndex <= lowerIndex {
            
            upperTempValue = upperValue
        }
        
        return upperTempValue
    }
    
    private func steppedValue(for value: Double) -> Double? {
        guard let stepDistance = stepDistance else { return nil }
        
        return round(value / stepDistance) * stepDistance
    }
    
    private func boundValue(value: Double, lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
}
