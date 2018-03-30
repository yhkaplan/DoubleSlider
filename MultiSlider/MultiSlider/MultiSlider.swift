//
//  MultiSlider.swift
//  MultiSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit
import QuartzCore

// The Color enum is populated with the default color values that Apple uses in
// standard UIKit controls
public enum Colors {
    static let defaultBlue = UIColor(red: 0.0, green: 0.51, blue: 0.98, alpha: 1.0)
    static let defaultGray = UIColor(red: 0.71, green: 0.71, blue: 0.71, alpha: 1.0)
    static let defaultWhite = UIColor.white
}

// The MultiSlider class is the main class that implements the MultiSlider
// control. Its main methods are marked open, so they can be subclassed and
// overridden to add or change behaviors
open class MultiSlider: UIControl {
    
    // Track values
    public var minValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var maxValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var lowerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    public var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // When stepDistance is set to nil, then steps are deactivated
    public var stepDistance: CGFloat? = nil //TODO: determine if property observer is needed
    
    // Override this to show only one label, etc.
    open var labelsAreHidden: Bool = false {
        didSet {
            minLabel.isHidden = labelsAreHidden
            maxLabel.isHidden = labelsAreHidden
        }
    }
    
    // Colors
    public var trackTintColor: UIColor = Colors.defaultGray {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    public var trackHighlightTintColor: UIColor = Colors.defaultBlue {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    public var thumbTintColor: UIColor = Colors.defaultWhite {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    public var roundedness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    // Render components
    public let trackLayer = MultiSliderTrackLayer()
    public let lowerThumbLayer = MultiSliderThumbLayer()
    public let upperThumbLayer = MultiSliderThumbLayer()
    public let minLabel = MultiSliderTextLayer()
    public let maxLabel = MultiSliderTextLayer()
    
    var previousLocation = CGPoint()
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override open var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayer(trackLayer)
        setupLayer(lowerThumbLayer)
        setupLayer(upperThumbLayer)
        setupLayer(minLabel)
        setupLayer(maxLabel)
        
        updateLayerFrames()
    }
    
    // This _must_ be a generic in order to use both CALayer and MSLayer
    // methods/parameters
    private func setupLayer<T: MultiSliderLayer>(_ msLayer: T) {
        msLayer.multiSlider = self
        msLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(msLayer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
    
    // TODO: simply this func
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // Check drag distance
        let dragDistance = Double(location.x - previousLocation.x)
        let dragValue = (maxValue - minValue) * dragDistance / Double(bounds.width - thumbWidth)
        
        previousLocation = location
        
        // Update values
        if lowerThumbLayer.isHighlighted {
            lowerValue += dragValue
            lowerValue = boundValue(value: lowerValue, lowerValue: minValue, upperValue: upperValue)
        } else if upperThumbLayer.isHighlighted {
            upperValue += dragValue
            upperValue = boundValue(value: upperValue, lowerValue: lowerValue, upperValue: maxValue)
        }
        
        // update values
        // Note: currently using target action pattern, but prob better to use swifty delegate pattern
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
    }
    
    private func boundValue(value: Double, lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
}

// This is the protocol that all CALayer/CATextLayer components
// used by MultiSlider. It ensures they contain a weak delegate
// to MultiSlider
// Swift bug report about this error message: https://bugs.swift.org/browse/SR-6265
protocol MultiSliderLayer: class where Self: CALayer  {
    weak var multiSlider: MultiSlider? { get set }
}

// MultiSliderThumbLayer represents the each of the draggable
// thumb layers that indicate the minimum and maximum values
// in the range
// I decided not to make this class open because it is very small,
// meaning that developers could make their own custom CALayer
// subclass in the same amount of time as it would take to subclass
// this one
public class MultiSliderThumbLayer: CALayer, MultiSliderLayer {
    weak var multiSlider: MultiSlider?
    
    var isHighlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func draw(in ctx: CGContext) {
        guard let slider = multiSlider else { return }
        
        let insetSize: CGFloat = 2.0
        let thumbFrame = bounds.insetBy(dx: insetSize, dy: insetSize)
        let cornerRadius = thumbFrame.height * slider.roundedness / 2.0
        let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
        
        // Fill with shadow
        let shadowColor = Colors.defaultGray.cgColor
        ctx.setShadow(offset: CGSize(width: 0.0, height: 2.0), blur: 4.0, color: shadowColor)
        ctx.setFillColor(slider.thumbTintColor.cgColor)
        ctx.addPath(thumbPath.cgPath)
        ctx.fillPath()
        
        // Outline
        ctx.setStrokeColor(shadowColor)
        ctx.setLineWidth(0.25)
        ctx.addPath(thumbPath.cgPath)
        ctx.strokePath()
        
        // Set color for highlighted thumb picker (move somewhere else)??
        if isHighlighted {
            ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
            ctx.addPath(thumbPath.cgPath)
            ctx.fillPath()
        }
    }
}

// MultiSliderTrackLayer represents the colorized space between
// the two thumb layers
// I decided not to make this class open because it is very small,
// meaning that developers could make their own custom CALayer
// subclass in the same amount of time as it would take to subclass
// this one
public class MultiSliderTrackLayer: CALayer, MultiSliderLayer {
    weak var multiSlider: MultiSlider?
    
    override public func draw(in ctx: CGContext) {
        guard let slider = multiSlider else { return }
        
        // Clip
        let cornerRadius = bounds.height * slider.roundedness / 2.0
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        // Fill track
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        // Fill highlighted range
        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let lowerValuePosition = CGFloat(slider.positionForValue(value: slider.lowerValue))
        let upperValuePosition = CGFloat(slider.positionForValue(value: slider.upperValue))
        let rect = CGRect(x: lowerValuePosition,
                          y: 0.0,
                          width: upperValuePosition - lowerValuePosition,
                          height: bounds.height)
        ctx.fill(rect)
    }
}

public class MultiSliderTextLayer: CATextLayer, MultiSliderLayer {
    weak var multiSlider: MultiSlider?
}
