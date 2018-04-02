//
//  ViewController.swift
//  MultiSliderDemo
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit
import MultiSlider

class ViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    public let labels: [(label: String, value: Int)] = [
        ("$0", 0),
        ("$15", 15),
        ("$25", 25),
        ("$50", 50),
        ("$75", 75),
        ("$100", 100),
        ("$150", 150),
        ("No limit", -1)
    ]
    
    override func viewDidLoad() {
        let height: CGFloat = 34.0 //TODO: make this the default height
        let frame = CGRect(x: backgroundView.bounds.minX,
                           y: backgroundView.bounds.midY - (height / 2.0),
                           //TODO: track down why the width is incorrect
                           width: backgroundView.bounds.width - 40.0,
                           height: height)
        
        let multiSlider = MultiSlider(frame: frame)
        multiSlider.translatesAutoresizingMaskIntoConstraints = false //true?
        multiSlider.labelDelegate = self
        multiSlider.numberOfSteps = 8
        multiSlider.addTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
        
        backgroundView.addSubview(multiSlider)
    }
    
    @objc func printVal(_ control: MultiSlider) {
        //print("Lower: \(control.lowerValue) Upper: \(control.upperValue)")
    }
}

extension ViewController: LabelDelegate {
    func labelForStep(at index: Int) -> String? {
        return labels.item(at: index)?.label
    }
}
