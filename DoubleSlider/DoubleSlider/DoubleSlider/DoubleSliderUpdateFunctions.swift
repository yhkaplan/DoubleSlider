//
//  DoubleSliderUpdateFunctions.swift
//  DoubleSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit

// MARK: General update funcs

extension DoubleSlider {
    
    // When stepDistance is set to nil, then steps are deactivated
    private var stepDistance: CGFloat { //TODO: check
        guard let numberOfSteps = numberOfSteps else {
            return 0.0
        }
        
        let distance = maxValue / Double(numberOfSteps)
        return bounds.width * CGFloat(distance)
    }
    
    open func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true) // Prevents interaction while updating
        
        //TODO: simplify below into helper methods / closures
        // Update lower values
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        var lowerX = lowerThumbCenter - thumbWidth / 2.0
        
        if let numberOfSteps = numberOfSteps, numberOfSteps > 0 { //TODO: make this extension or helper method
            
            lowerX = CGFloat(roundf(Float(lowerX / stepDistance))) * stepDistance
        }
        
        lowerThumbLayer.frame = CGRect(x: lowerX, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        // Update upper values
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        var upperX = upperThumbCenter - thumbWidth / 2.0
        
        if let numberOfSteps = numberOfSteps, numberOfSteps > 0 {
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
}

// MARK: Label related funcs

extension DoubleSlider {
        
    private func updateLabelValues() {
        
        let rawMinString = "\(lowerValue.roundedToTwoPlaces)"
        let rawMaxString = "\(upperValue.roundedToTwoPlaces)"
        
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: Colors.textGray
        ]
        
        if let currentStep = currentStep(for: lowerValue),
            let label = labelDelegate?.labelForStep(at: currentStep) {
            minLabel.string = NSAttributedString(string: label, attributes: attributes)
        
        } else {
            minLabel.string = NSAttributedString(string: rawMinString, attributes: attributes)
        }
        
        
        if let currentStep = currentStep(for: upperValue),
            let label = labelDelegate?.labelForStep(at: currentStep) {
            maxLabel.string = NSAttributedString(string: label, attributes: attributes)
            
        } else {
            maxLabel.string = NSAttributedString(string: rawMaxString, attributes: attributes)
        }
        setNeedsLayout()
    }
    
    private func currentStep(for value: Double) -> Int? {
        guard let numberOfSteps = numberOfSteps else { return nil }
        
        return Int(round((value - minValue) * Double(numberOfSteps - 1)))
    }
    
    // TODO: split into smaller funcs
    private func updateLabelPositions() {
        let labelSize = CGSize(width: 55, height: 20)
        minLabel.frame.size = labelSize
        maxLabel.frame.size = labelSize
        
        let minimumSpaceBetweenLabels: CGFloat = 0.0
        let spaceBetweenThumbAndLabel: CGFloat = 18.0
        
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
