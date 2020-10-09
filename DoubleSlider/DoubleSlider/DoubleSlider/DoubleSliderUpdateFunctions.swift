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
        
        trackLayer.frame = bounds.insetBy(dx: layerInset, dy: 18.0)
        trackLayer.setNeedsDisplay()
        
        updateLabelValues()
        updateLabelSizes()
        updateLabelPositions()
        
        minLabel.alignmentMode = .center
        maxLabel.alignmentMode = .center

        CATransaction.commit()
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
    
    private func updateLabelPositions() {
        let newMinLabelCenter = labelCenter(for: lowerThumbLayer)
        let newMaxLabelCenter = labelCenter(for: upperThumbLayer)
        
        let newRightmostXInMinLabel = newMinLabelCenter.x + minLabel.frame.width / 2.0
        let newLeftmostXInMaxLabel = newMaxLabelCenter.x - maxLabel.frame.width / 2.0
        let newSpaceBetweenLabels = newLeftmostXInMaxLabel - newRightmostXInMinLabel
        
        if newSpaceBetweenLabels > minimumSpaceBetweenLabels { // No position conflict between labels
            minLabel.position = newMinLabelCenter
            maxLabel.position = newMaxLabelCenter
            
            // Position conflict between lowerLabel and lowerLabelMargin
            if minLabel.frame.minX < lowerLabelMargin {
                minLabel.frame.origin.x = minLabel.frame.minX + 4.0
            }

            // Position conflict between upperLabel and upperLabelMargin
            if maxLabel.frame.maxX > upperLabelMargin {
                maxLabel.frame.origin.x = frame.width - maxLabel.frame.width - 4.0
            }
            
        } else { // Positions conflict between labels
            let increaseAmount: CGFloat = minimumSpaceBetweenLabels - newSpaceBetweenLabels
            minLabel.position = CGPoint(x: newMinLabelCenter.x - increaseAmount / 2.0, y: newMinLabelCenter.y)
            maxLabel.position = CGPoint(x: newMaxLabelCenter.x + increaseAmount / 2.0, y: newMaxLabelCenter.y)

            // Adjust labels positions when they collide at the left lowerLabelMargin
            if minLabel.frame.minX < lowerLabelMargin {
                minLabel.frame.origin.x = lowerLabelMargin
                maxLabel.frame.origin.x = minimumSpaceBetweenLabels + minLabel.frame.width
            }
            
            // Adjust labels positions when they collide at the right upperLabelMargin
            if maxLabel.frame.maxX > upperLabelMargin {
                maxLabel.frame.origin.x = upperLabelMargin - maxLabel.frame.width
                minLabel.frame.origin.x = maxLabel.frame.origin.x - minimumSpaceBetweenLabels - minLabel.frame.width
            }
        }
    }
}
