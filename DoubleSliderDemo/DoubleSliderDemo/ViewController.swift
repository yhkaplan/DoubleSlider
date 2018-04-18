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
    }
    
    private func makeLabels() {
        for i in stride(from: 0, to: 300, by: 5) {
            labels.append("$\(i)")
        }
        labels.append("No limit")
    }
    
    private func setupDoubleSlider() {
        let height: CGFloat = 34.0 //TODO: make this the default height
        let width = view.bounds.width - 40.0
        
        let frame = CGRect(
            x: backgroundView.bounds.minX,
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
        doubleSlider.upperLabelMargin = view.bounds.maxX
        
        doubleSlider.lowerValueStepIndex = 0
        doubleSlider.upperValueStepIndex = labels.count - 1
        
        doubleSlider.addTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
        doubleSlider.addTarget(self, action: #selector(finishChanging(_:)), for: .editingDidEnd)
    
        backgroundView.addSubview(doubleSlider)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        doubleSlider.removeTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
    }
    
    @objc func printVal(_ control: DoubleSlider) {
        print("Lower: \(control.lowerValue) Upper: \(control.upperValue)")
    }
    
    @objc func finishChanging(_ control: DoubleSlider) {
        print("Final Lower: \(control.lowerValueStepIndex) Final Upper: \(control.upperValueStepIndex)")
    }
}

extension ViewController: DoubleSliderLabelDelegate {
    
    func labelForStep(at index: Int) -> String? {
        return labels.item(at: index)
    }
    
}
