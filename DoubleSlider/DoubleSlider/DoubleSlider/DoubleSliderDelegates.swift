
// This protocol allows you to display a custom label
// for each step index selected. Labels must be set to on
// and the number of steps must be set.
public protocol DoubleSliderLabelDelegate: class {
    func labelForStep(at index: Int) -> String?
}

// I choose not to combine the two delegates below in
// order to make it clearer which protocol is being conformed to
// and for what reason, as well as avoid an unneeded @objc annotation

// This protocol allows you to use a Swiftier delegate pattern
// rather than rely on notifications for updating values
// Equivalent to `valueChanged` notification
public protocol DoubleSliderValueChangedDelegate: class {
    func valueChanged(for doubleSlider: DoubleSlider)
}

// This protocol allows you to use a Swiftier delegate pattern
// rather than rely on notifications for updating values
// Equivalent to `editingDidEnd` notification
public protocol DoubleSliderEditingDidEndDelegate: class {
    func editingDidEnd(for doubleSlider: DoubleSlider)
}
