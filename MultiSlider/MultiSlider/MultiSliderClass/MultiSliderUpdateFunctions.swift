//
//  MultiSliderUpdateFunctions.swift
//  MultiSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit

// MARK: General update funcs

extension MultiSlider {
    
    // When stepDistance is set to nil, then steps are deactivated
    private var stepDistanceDouble: Double { //TODO: determine if property observer is needed
        guard let numberOfSteps = numberOfSteps else { return 0 }
        return maxValue / Double(numberOfSteps)
    }
    
    private var stepDistanceCGFloat: CGFloat { //TODO: check
        return bounds.width * CGFloat(stepDistanceDouble)
    }
    
    open func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true) // Prevents interaction while updating
        
        trackLayer.frame = bounds.insetBy(dx: layerInset, dy: bounds.height / 2.15) //TODO: may be incorrect
        trackLayer.setNeedsDisplay()
        
        //TODO: simplify below into helper methods / closures
        // Update lower values
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        var lowerX = lowerThumbCenter - thumbWidth / 2.0
        
        if let numberOfSteps = numberOfSteps, numberOfSteps > 0 { //TODO: make this extension or helper method
            
            lowerX = CGFloat(roundf(Float(lowerX / stepDistanceCGFloat))) * stepDistanceCGFloat
        }
        
        lowerThumbLayer.frame = CGRect(x: lowerX, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        // Update upper values
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        var upperX = upperThumbCenter - thumbWidth / 2.0
        
        if let numberOfSteps = numberOfSteps, numberOfSteps > 0 {
            upperX = CGFloat(roundf(Float(upperX / stepDistanceCGFloat))) * stepDistanceCGFloat
        }
        
        upperThumbLayer.frame = CGRect(x: upperX, y: 0.0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        updateLabelPositions()
        updateLabelValues()
        minLabel.alignmentMode = kCAAlignmentCenter
//        minLabel.display()
//        minLabel.setNeedsDisplay()
        maxLabel.alignmentMode = kCAAlignmentCenter
//        maxLabel.display()
//        maxLabel.setNeedsDisplay()
        CATransaction.commit()
    }
    
    //TODO: simplify with more constants
    public func positionForValue(value: Double) -> Double {
        let widthDifference = Double(bounds.width - thumbWidth)
        return widthDifference * (value - minValue) / (maxValue - minValue) + Double(thumbWidth / 2.0)
    }
}

// MARK: Label related funcs

extension MultiSlider {
        
    private func updateLabelValues() {
        let numberFormatter = NumberFormatter() //TODO: move to extension
        numberFormatter.numberStyle = NumberFormatter.Style.decimal//TODO: needed?

        guard let rawMinString = numberFormatter.string(from: lowerValue as NSNumber),
            let rawMaxString = numberFormatter.string(from: upperValue as NSNumber) else {
                return
        }

        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12.0),
            NSAttributedStringKey.foregroundColor: UIColor.black.cgColor
        ]
        
//        let stepNumber = (lowerValue - minValue) *   numberOfSteps ?? 0
//
//        if let label = labelDelegate?.labelForStep(at: ) {
//            minLabel.string = NSAttributedString(string: label, attributes: attributes)
//        } else {
            minLabel.string = NSAttributedString(string: rawMinString, attributes: attributes)
//        }
        
        maxLabel.string = NSAttributedString(string: rawMaxString, attributes: attributes)
        
        setNeedsLayout()
    }
    
    private func updateLabelPositions() {
        let labelSize = CGSize(width: 40, height: 20)
        minLabel.frame.size = labelSize
        maxLabel.frame.size = labelSize
        
        let minimumSpaceBetweenLabels: CGFloat = 8.0
        let spaceBetweenThumbAndLabel: CGFloat = 20.0
        
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
