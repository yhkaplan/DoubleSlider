//
//  MultiSlider.swift
//  MultiSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit

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
    
    public var numberOfSteps: Int? = nil {
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
    
    public weak var labelDelegate: LabelDelegate?
    
    // Render components
    public let trackLayer = MultiSliderTrackLayer()
    public let lowerThumbLayer = MultiSliderThumbLayer()
    public let upperThumbLayer = MultiSliderThumbLayer()
    public let minLabel = MultiSliderTextLayer()
    public let maxLabel = MultiSliderTextLayer()
    
    var previousLocation = CGPoint()
    
    open var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override open var frame: CGRect {
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
    
    // This _must_ be a generic in order to use both CALayer and MSLayer
    // methods/parameters
    private func setupLayer<T: MultiSliderLayer>(_ msLayer: T) {
        msLayer.multiSlider = self
        msLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(msLayer)
    }
}
