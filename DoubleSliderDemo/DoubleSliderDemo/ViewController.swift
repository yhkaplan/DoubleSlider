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
    
    public let labels: [(label: String, value: Int)] = [
        ("$0", 0),
        ("$10", 15),
        ("$25", 25),
        ("$50", 50),
        ("$100", 100),
        ("$250", 250),
        ("$500", 500),
        ("No limit", -1)
    ]
    
    override func viewDidLoad() {       
        let height: CGFloat = 34.0 //TODO: make this the default height
        let width = view.bounds.width - 40.0
        let frame = CGRect(x: backgroundView.bounds.minX,
                           y: backgroundView.bounds.midY - (height / 2.0),
                           width: width,
                           height: height)
        
        let doubleSlider = DoubleSlider(frame: frame)
        doubleSlider.translatesAutoresizingMaskIntoConstraints = false
//        doubleSlider.labelDelegate = self
//        doubleSlider.numberOfSteps = labels.count
        doubleSlider.addTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
        
        backgroundView.addSubview(doubleSlider)
    }
    
    @objc func printVal(_ control: DoubleSlider) {
        //print("Lower: \(control.lowerValue) Upper: \(control.upperValue)")
    }
}

extension ViewController: DoubleSliderLabelDelegate {
    func labelForStep(at index: Int) -> String? {
        return labels.item(at: index)?.label
    }
}
