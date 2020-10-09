//
//  DoubleSlider.swift
//  DoubleSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit

// The DoubleSlider class is the main class that implements the DoubleSlider
// control. Its main methods are marked open, so they can be subclassed and
// overridden to add or change behaviors
@IBDesignable open class DoubleSlider: UIControl {
    
    // Public vars
    
    // Track values
    public private(set) var minValue: Double = 0.0
    
    public private(set) var maxValue: Double = 1.0
    
    @IBInspectable public var lowerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable public var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable public var numberOfSteps: Int = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // lowerValue as a step index (int)
    public var lowerValueStepIndex: Int {
        // Return 0 if steps don't exist
        get {
            return stepIndex(for: lowerValue) ?? 0
        }
        // Don't change lowerValue if steps aren't set
        set(newIndex) {
            lowerValue = value(for: newIndex) ?? lowerValue
            updateLayerFrames()
        }
    }

    // upperValue as a step index (int)
    public var upperValueStepIndex: Int {
        // Return 0 if steps don't exist
        get {
            return stepIndex(for: upperValue) ?? 0
        }
        // Don't change upperValue if steps aren't set
        set(newIndex) {
            upperValue = value(for: newIndex) ?? upperValue
            updateLayerFrames()
        }
    }
    
    // This bool turns off traditional stepping behavior,
    // allowing for custom labels set at given intervals
    // that don't "jump" from step to step, but instead
    // transition smoothly
    @IBInspectable public var smoothStepping: Bool = false {
        didSet {
            updateLayerFrames()
        }
    }
    
    // This inset is shared between the thumb layers and
    // the track layer so the track layer doesn't extend
    // beyond the thumbs. Also, this value makes sure
    // that the shadows found on the thumb layer aren't
    // cut off.
    @IBInspectable public var layerInset: CGFloat = 5.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Override this to show only one label, etc.
    @IBInspectable open var labelsAreHidden: Bool = false {
        didSet {
            minLabel.isHidden = labelsAreHidden
            maxLabel.isHidden = labelsAreHidden
        }
    }
    
    // MARK: - Colors
    
    @IBInspectable public var trackTintColor: UIColor = Colors.defaultGray {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var trackHighlightTintColor: UIColor = Colors.defaultBlue {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var thumbTintColor: UIColor = Colors.defaultWhite {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    // MARK: - General appearance
    
    @IBInspectable public var roundedness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    // This is a class var so it can be overridden at will
    public class var labelAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: UIFont.systemFont(ofSize: 14.0),
            .foregroundColor: Colors.textGray
        ]
    }
    
    @IBInspectable public var minimumSpaceBetweenLabels: CGFloat = 5.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable public var spaceBetweenThumbAndLabel: CGFloat = 18.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // The minimum distance from minX of the bounds that the lowerLabel can move to
    // Make this a positive value to allow the label to go beyond the bounds
    // Make this negative value to make the label stay away from the edge of the bounds
    @IBInspectable public var lowerLabelMarginOffset: CGFloat = 0.0

    // The maximum distance from maxX of the bounds that the upperLabel can move to
    // Make this a positive value to allow the label to go beyond the bounds
    // Make this negative value to make the label stay away from the edge of the bounds
    @IBInspectable public var upperLabelMarginOffset: CGFloat = 0.0
    
    // The furthest left that a label can move
    var lowerLabelMargin: CGFloat {
        return bounds.minX - lowerLabelMarginOffset
    }
    
    // The furthest right that a label can move
    var upperLabelMargin: CGFloat {
        return bounds.maxX + upperLabelMarginOffset
    }
    
    public weak var labelDelegate: DoubleSliderLabelDelegate? {
        didSet {
            updateLayerFrames()
        }
    }
    
    public weak var valueChangedDelegate: DoubleSliderValueChangedDelegate?
    
    public weak var editingDidEndDelegate: DoubleSliderEditingDidEndDelegate?
    
    // Render components
    public let trackLayer = DoubleSliderTrackLayer()
    public let lowerThumbLayer = DoubleSliderThumbLayer()
    public let upperThumbLayer = DoubleSliderThumbLayer()
    public let minLabel = CATextLayer()
    public let maxLabel = CATextLayer()
    
    var previousLocation = CGPoint()
    
    open var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override open var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override open var bounds: CGRect {
        // Without this, the sizing in AutoLayout would be off
        didSet {
            updateLayerFrames()
        }
    }
    
    // MARK: - Internal funcs/vars
    
    var stepDistance: Double? {
        guard numberOfSteps > 0 else { return nil }
        
        return maxValue / Double(numberOfSteps)
    }
    
    func value(for stepIndex: Int) -> Double? {
        guard let stepDistance = stepDistance else {
            return nil
        }
        
        // This prevents the thumb from looking slightly off at minValue
        if stepIndex == 0 { return minValue }
        // This prevents the thumb from looking slightly off at maxValue
        if stepIndex == numberOfSteps - 1 { return maxValue }
        
        return Double(stepIndex + 1) * stepDistance - (stepDistance / 2.0)
    }
    
    func stepIndex(for value: Double) -> Int? {
        guard numberOfSteps > 0 else { return nil }
        
        return Int(round((value - minValue) * Double(numberOfSteps - 1)))
    }
    
    // MARK: - Initializers
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    // MARK: - Private func
    
    private func initialSetup() {
        // The reason that I put the upperThumbLayer before the lowerThumbLayer is to make the
        // lowerThumbLayer be above the upperThumbLayer in the z axis, which reflects the priority
        // logic when selecting one thumbLayer when they both overlap. Without this, the lowerLayer is
        // prioritized even though it is below the upperThumbLayer in the z axis
        [trackLayer, upperThumbLayer, lowerThumbLayer, minLabel, maxLabel].forEach { caLayer in
            // Set the doubleSlider delegate for CALayers that
            // conform to DoubleSliderLayer protocol
            if let caLayer = caLayer as? DoubleSliderLayer {
                caLayer.doubleSlider = self
            }
            
            caLayer.contentsScale = UIScreen.main.scale
            layer.addSublayer(caLayer)
        }
    }
}
