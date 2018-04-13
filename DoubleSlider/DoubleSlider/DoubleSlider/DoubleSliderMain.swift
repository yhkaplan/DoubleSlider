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
open class DoubleSlider: UIControl {
    
    // Track values
    public private(set) var minValue: Double = 0.0
    
    public private(set) var maxValue: Double = 1.0
    
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
    
    public var numberOfSteps: Int = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // This bool turns off traditional stepping behavior,
    // allowing for custom labels set at given intervals
    // that don't "jump" from step to step, but instead
    // transition smoothly
    public var smoothStepping: Bool = false {
        didSet {
            updateLayerFrames()
        }
    }
    
    // This inset is shared between the thumb layers and
    // the track layer so the track layer doesn't extend
    // beyond the thumbs. Also, this value makes sure
    // that the shadows found on the thumb layer aren't
    // cut off.
    public var layerInset: CGFloat = 3.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Override this to show only one label, etc.
    open var labelsAreHidden: Bool = false {
        didSet {
            minLabel.isHidden = labelsAreHidden
            maxLabel.isHidden = labelsAreHidden
        }
    }
    
    // MARK: - Colors
    
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
    
    // MARK: - General appearance
    
    public var roundedness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    public let minimumSpaceBetweenLabels: CGFloat = 0.0
    
    public let spaceBetweenThumbAndLabel: CGFloat = 18.0
    
    // This value is the farthest left that a label can move
    public lazy var lowerLabelMargin: CGFloat = 0.0
    
    // This value is the farthest right that a label can move
    public lazy var upperLabelMargin: CGFloat = frame.width
    
    public weak var labelDelegate: DoubleSliderLabelDelegate?
    
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
    
    override open var frame: CGRect { //TODO: is this needed?
        didSet {
            updateLayerFrames()
        }
    }
    
    // MARK: - Initializers
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    private func setupLayer(_ msLayer: CALayer) {
        
        // Set the doubleSlider delegate for CALayers that
        // conform to DoubleSliderLayer protocol
        if let msLayer = msLayer as? DoubleSliderLayer {
            msLayer.doubleSlider = self
        }
        
        msLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(msLayer)
    }
}
