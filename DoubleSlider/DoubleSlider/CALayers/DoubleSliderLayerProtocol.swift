
// This is the protocol that all CALayer components
// used by DoubleSlider conform to. It ensures they
// contain a weak delegate to DoubleSlider
protocol DoubleSliderLayer: class {
    var doubleSlider: DoubleSlider? { get set }
}
