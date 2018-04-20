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
    @IBOutlet weak var redDoubleSlider: DoubleSlider!
    
    var labels: [String] = []
    var doubleSlider: DoubleSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeLabels()
        setupDoubleSlider()
        
        redDoubleSlider.labelDelegate = self
        redDoubleSlider.numberOfSteps = labels.count
        redDoubleSlider.labelsAreHidden = false
        redDoubleSlider.smoothStepping = true
        redDoubleSlider.lowerLabelMargin = -20
        redDoubleSlider.upperLabelMargin = doubleSlider.frame.maxX + 20
    }
    
    private func makeLabels() {
        for i in stride(from: 0, to: 200, by: 10) {
            labels.append("$\(i)")
        }
        labels.append("No limit")
    }
    
    private func setupDoubleSlider() {
        let height: CGFloat = 38.0 //TODO: make this the default height
        let width = view.bounds.width - 38.0 
        
        let frame = CGRect(
            x: backgroundView.bounds.minX - 2.0,
            y: backgroundView.bounds.midY - (height / 2.0),
            width: width,
            height: height
        )
    
        doubleSlider = DoubleSlider(frame: frame)
        doubleSlider.translatesAutoresizingMaskIntoConstraints = false
        
        doubleSlider.labelDelegate = self
        doubleSlider.numberOfSteps = labels.count
        doubleSlider.smoothStepping = true
        doubleSlider.lowerLabelMargin = -20
        doubleSlider.upperLabelMargin = doubleSlider.frame.maxX + 20
        
        doubleSlider.lowerValueStepIndex = 0
        doubleSlider.upperValueStepIndex = labels.count - 1
        
        // You can use traditional notifications
        doubleSlider.addTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
        // Or Swifty delegates
        doubleSlider.editingDidEndDelegate = self
        
        backgroundView.addSubview(doubleSlider)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        doubleSlider.removeTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
    }
    
    @objc func printVal(_ doubleSlider: DoubleSlider) {
        print("Lower: \(doubleSlider.lowerValue) Upper: \(doubleSlider.upperValue)")
    }
}

extension ViewController: DoubleSliderEditingDidEndDelegate {
    func editingDidEnd(for doubleSlider: DoubleSlider) {
        print("Lower Step Index: \(doubleSlider.lowerValueStepIndex) Upper Step Index: \(doubleSlider.upperValueStepIndex)")
    }
}

extension ViewController: DoubleSliderLabelDelegate {
    func labelForStep(at index: Int) -> String? {
        return labels.item(at: index)
    }
}
