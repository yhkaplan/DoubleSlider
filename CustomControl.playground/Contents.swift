//: A UIKit based Playground for presenting user interface
  
import UIKit
import QuartzCore
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let frame = CGRect(x: 0, y: 0, width: 375, height: 20)
        let control = CustomControl(frame: frame)
        
        control.addTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
        
        view.addSubview(control)
        
        let frame2 = CGRect(x: 0, y: 50, width: 375, height: 10)
        let slider = UISlider(frame: frame2)
        view.addSubview(slider)
        
        self.view = view
    }
    
    @objc func printVal(_ control: CustomControl) {
        //print("Lower: \(control.lowerValue) Upper: \(control.upperValue)")
    }
}

class CustomControl: UIControl {
    
    // Track values
    var minValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var maxValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var lowerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    // Colors
    var trackTintColor: UIColor = UIColor.lightGray {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackHighlightTintColor: UIColor = UIColor.blue {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var thumbTintColor: UIColor = UIColor.white {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    var roundedness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    // Render components
    let trackLayer = CustomControlTrackLayer()
    let lowerThumbLayer = CustomControlThumbLayer()
    let upperThumbLayer = CustomControlThumbLayer()
    
    var previousLocation = CGPoint()
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.customControl = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.customControl = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)

        upperThumbLayer.customControl = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
        
        updateLayerFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true) // Prevents interaction while updating
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3) //TODO: may be incorrect
        trackLayer.setNeedsDisplay()
        
        //TODO: simplify below into helper methods / closures
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        let lowerX = lowerThumbCenter - thumbWidth / 2.0
        lowerThumbLayer.frame = CGRect(x: lowerX, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        let upperX = upperThumbCenter - thumbWidth / 2.0
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
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.isHighlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.isHighlighted = true
        }
        
        return lowerThumbLayer.isHighlighted || upperThumbLayer.isHighlighted
    }
    
    // TODO: simply this func
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
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
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
    }
    
    private func boundValue(value: Double, lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
}

class CustomControlThumbLayer: CALayer {
    weak var customControl: CustomControl?
    
    var isHighlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(in ctx: CGContext) {
        guard let slider = customControl else { return }
        
        let insetSize: CGFloat = 2.0
        let thumbFrame = bounds.insetBy(dx: insetSize, dy: insetSize)
        let cornerRadius = thumbFrame.height * slider.roundedness / 2.0
        let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
        
        // Fill with shadow
        let shadowColor = UIColor.gray.cgColor
        ctx.setShadow(offset: CGSize(width: 0.0, height: 1.0), blur: 1.0, color: shadowColor)
        ctx.setFillColor(slider.thumbTintColor.cgColor)
        ctx.addPath(thumbPath.cgPath)
        ctx.fillPath()
        
        // Outline
        ctx.setStrokeColor(shadowColor)
        ctx.setLineWidth(0.5)
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

class CustomControlTrackLayer: CALayer {
    weak var customControl: CustomControl?
    
    override func draw(in ctx: CGContext) {
        guard let slider = customControl else { return }
        
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

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
