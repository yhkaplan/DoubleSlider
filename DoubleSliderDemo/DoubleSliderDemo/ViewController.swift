//
//  ViewController.swift
//  DoubleSliderDemo
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit
import DoubleSlider

class ViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var normalSlider: UISlider!
    
    public var labels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeLabels()
        setupDoubleSlider()
    }
    
    private func makeLabels() {
        for i in stride(from: 0, to: 300, by: 10) {
            labels.append("$\(i)")
        }
        labels.append("No limit")
    }
    
    private func setupDoubleSlider() {
        let height: CGFloat = 34.0 //TODO: make this the default height
        let width = view.bounds.width - 40.0
        let frame = CGRect(x: backgroundView.bounds.minX,
        y: backgroundView.bounds.midY - (height / 2.0),
        width: width,
        height: height)
    
        let doubleSlider = DoubleSlider(frame: frame)
        doubleSlider.translatesAutoresizingMaskIntoConstraints = false
        doubleSlider.labelDelegate = self
        doubleSlider.numberOfSteps = labels.count
        doubleSlider.smoothStepping = true
        doubleSlider.addTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
    
        backgroundView.addSubview(doubleSlider)
    }
    
    @objc func printVal(_ control: DoubleSlider) {
        print("Lower: \(control.lowerValue) Upper: \(control.upperValue)")
    }
}

extension ViewController: DoubleSliderLabelDelegate {
    func labelForStep(at index: Int) -> String? {
        return labels.item(at: index)
    }
}
