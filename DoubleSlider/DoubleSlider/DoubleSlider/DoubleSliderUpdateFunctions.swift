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
        // Prevents interaction while updating
        CATransaction.setDisableActions(true)

        // Get lower values
        let lowerThumbCenter = positionForValue(value: lowerValue)
        let lowerThumbMinX = lowerThumbCenter - thumbWidth / 2.0
        
        // Get upper values
        let upperThumbCenter = positionForValue(value: upperValue)
        let upperThumbMinX = upperThumbCenter - thumbWidth / 2.0
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbMinX, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        upperThumbLayer.frame = CGRect(x: upperThumbMinX, y: 0.0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        trackLayer.frame = bounds.insetBy(dx: layerInset, dy: 18.0) //TODO: may be incorrect
        trackLayer.setNeedsDisplay()
        
        updateLabelValues()
        updateLabelSizes()
        updateLabelPositions()
        
        minLabel.alignmentMode = kCAAlignmentCenter
        maxLabel.alignmentMode = kCAAlignmentCenter

        CATransaction.commit()
    }
    
    //TODO: think of a better name for this?
    var stepDistance: CGFloat {
        guard let stepDistanceAsDouble = stepDistanceAsDouble else {
            return 0.0
        }
        
        return bounds.width * CGFloat(stepDistanceAsDouble)
    }
    
    func positionForValue(value: Double) -> CGFloat {
        let widthDifference = bounds.width - thumbWidth
        return widthDifference * CGFloat(value - minValue) / CGFloat(maxValue - minValue) + (thumbWidth / 2.0)
    }
}

// MARK: Label related funcs

extension DoubleSlider {
    
    // If a custom label is set for the lower or upper value,
    // then that label is used instead of the raw value
    private func updateLabelValues() {
        if let stepIndex = stepIndex(for: lowerValue),
            let label = labelDelegate?.labelForStep(at: stepIndex) {
            minLabel.string = label.asAttributedString
        
        } else {
            minLabel.string = lowerValue.asRoundedAttributedString
        }
        
        if let stepIndex = stepIndex(for: upperValue),
            let label = labelDelegate?.labelForStep(at: stepIndex) {
            maxLabel.string = label.asAttributedString
            
        } else {
            maxLabel.string = upperValue.asRoundedAttributedString
        }
        setNeedsLayout()
    }
    
    private func labelCenter(for label: DoubleSliderThumbLayer) -> CGPoint {
        let labelY = trackLayer.frame.midY - (minLabel.frame.height / 2.0) - spaceBetweenThumbAndLabel
        return CGPoint(x: label.frame.midX, y: labelY)
    }
    
    private func updateLabelSizes() {
        [minLabel, maxLabel].forEach { label in
            let width = (label.string as? NSAttributedString)?.size().width ?? 55.0
            label.frame.size = CGSize(width: width, height: 20.0)
        }
    }
    
    // TODO: split into smaller funcs
    private func updateLabelPositions() {
        let newMinLabelCenter = labelCenter(for: lowerThumbLayer)
        let newMaxLabelCenter = labelCenter(for: upperThumbLayer)
        
        let newRightmostXInMinLabel = newMinLabelCenter.x + minLabel.frame.width / 2.0
        let newLeftmostXInMaxLabel = newMaxLabelCenter.x - maxLabel.frame.width / 2.0
        let newSpaceBetweenLabels = newLeftmostXInMaxLabel - newRightmostXInMinLabel
        
        if newSpaceBetweenLabels > minimumSpaceBetweenLabels {
            minLabel.position = newMinLabelCenter
            maxLabel.position = newMaxLabelCenter
            
            if minLabel.frame.minX < lowerLabelMargin {
                minLabel.frame.origin.x = minLabel.frame.minX + 4.0
            }
            
            if maxLabel.frame.maxX > upperLabelMargin {
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
