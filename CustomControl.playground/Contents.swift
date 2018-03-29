//: A UIKit based Playground for presenting user interface
  
import UIKit
import QuartzCore
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let frame = CGRect(x: 10, y: 50, width: 350, height: 32)
        let control = MultiSlider(frame: frame)
        control.stepDistance = control.frame.width / 10.0
        
        control.addTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
        
        view.addSubview(control)
        
        let frame2 = CGRect(x: 10, y: 150, width: 350, height: 10)
        let slider = UISlider(frame: frame2)
        view.addSubview(slider)
        
        self.view = view
    }
    
    @objc func printVal(_ control: MultiSlider) {
        //print("Lower: \(control.lowerValue) Upper: \(control.upperValue)")
    }
}

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.multiSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.multiSlider = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)

        upperThumbLayer.multiSlider = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
        
        minLabel.multiSlider = self
        minLabel.contentsScale = UIScreen.main.scale
        layer.addSublayer(minLabel)
        
        maxLabel.multiSlider = self
        maxLabel.contentsScale = UIScreen.main.scale
        layer.addSublayer(maxLabel)
        
        updateLayerFrames()
    }
    
    required public init?(coder aDecoder: NSCoder) {
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
        
        CATransaction.commit()
    }
    
    //TODO: simplify with more constants
    public func positionForValue(value: Double) -> Double {
        let widthDifference = Double(bounds.width - thumbWidth)
        return widthDifference * (value - minValue) / (maxValue - minValue) + Double(thumbWidth / 2.0)
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

// MultiSliderThumbLayer represents the each of the draggable
// thumb layers that indicate the minimum and maximum values
// in the range
// I decided not to make this class open because it is very small,
// meaning that developers could make their own custom CALayer
// subclass in the same amount of time as it would take to subclass
// this one
public class MultiSliderThumbLayer: CALayer {
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
public class MultiSliderTrackLayer: CALayer {
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

public class MultiSliderTextLayer: CATextLayer {
    weak var multiSlider: MultiSlider?
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
