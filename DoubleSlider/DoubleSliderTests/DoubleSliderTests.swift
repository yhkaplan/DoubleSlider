//
//  DoubleSliderTests.swift
//  DoubleSliderTests
//
//  Created by josh on 2018/04/16.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import XCTest

class DoubleSliderTests: XCTestCase {
    
    var labels: [String] = []
    var doubleSlider: DoubleSlider!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        doubleSlider.removeTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @objc func printVal(_ control: DoubleSlider) {
        print("Lower: \(control.lowerValue) Upper: \(control.upperValue)")
    }
    
    @objc func finishChanging(_ control: DoubleSlider) {
        print("Final Lower: \(control.stepIndexForLowerValue!) Final Upper: \(control.stepIndexForUpperValue!)")
    }
    
    private func makeLabels() {
        for i in stride(from: 0, to: 300, by: 10) {
            labels.append("$\(i)")
        }
        labels.append("No limit")
    }
    
    private func setupDoubleSlider() {
        let height: CGFloat = 38.0 //TODO: make this the default height
        let width = view.bounds.width - 40.0
        let frame = CGRect(x: backgroundView.bounds.minX,
                           y: backgroundView.bounds.midY - (height / 2.0),
                           width: width,
                           height: height)
        
        doubleSlider = DoubleSlider(frame: frame)
        doubleSlider.translatesAutoresizingMaskIntoConstraints = false
        
        doubleSlider.labelDelegate = self
        doubleSlider.numberOfSteps = labels.count
        doubleSlider.smoothStepping = true
        doubleSlider.lowerLabelMargin = -20
        doubleSlider.upperLabelMargin = view.bounds.maxX
        
        doubleSlider.addTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
        doubleSlider.addTarget(self, action: #selector(finishChanging(_:)), for: .editingDidEnd)
        
        backgroundView.addSubview(doubleSlider)
    }
}

class ViewController: DoubleSliderLabelDelegate {
    func labelForStep(at index: Int) -> String? {
        return labels.item(at: index)
    }
}
