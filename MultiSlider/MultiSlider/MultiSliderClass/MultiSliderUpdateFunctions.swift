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
    
    private func labelAt(_ index: Int) -> String? {
        return labels.item(at: index)?.label
    }
    
    // This is probably not the best approach. Generally, the
    // label names should match the values for api calls
    //TODO: find an approach that moves this func into an
    // external class that conforms to a protocol LabelProvidable
    // or something like that (a func that returns an optional
    // string named labelForStep(at:)
    // This functionality should almost certainly be external to
    // the slider
    private func labelForStep(at value: Double) -> String? {
        
        guard let stepDistance = stepDistance else { return "" }
        
        let numberOfSteps = round(maxValue / Double(stepDistance))
        
        // Making stepDistance or some other value that converts
        // CGFloat values like 65.0 to Double 0.125 would allow for below
        
        //TODO: change stepDistance into numberOfSteps
        let distanceInDoubleFormat = 1.0 / numberOfSteps
        
        
        switch value {
        case 0.0 ..< 1.0 * distanceInDoubleFormat:
            return labelAt(0)
            
        case 1.0 * distanceInDoubleFormat ..< 2.0 * distanceInDoubleFormat:
            return labelAt(1)
            
        default:
            return nil
        }
    }
        
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
        
        if let label = labelForStep(at: lowerValue) {
            minLabel.string = NSAttributedString(string: label, attributes: attributes)
        } else {
            minLabel.string = NSAttributedString(string: rawMinString, attributes: attributes)
        }
        
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
