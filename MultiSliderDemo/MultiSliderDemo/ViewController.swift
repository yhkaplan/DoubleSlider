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
    
    override func viewDidLoad() {
        let height: CGFloat = 32.0 //TODO: make this the default height
        let frame = CGRect(x: backgroundView.bounds.minX,
                           y: backgroundView.bounds.midY - (height / 2.0),
                           //TODO: track down why the width is incorrect
                           width: backgroundView.bounds.width - 40.0,
                           height: height)
        
        let multiSlider = MultiSlider(frame: frame)
        multiSlider.translatesAutoresizingMaskIntoConstraints = false //true?
        
        multiSlider.numberOfSteps = 4
        multiSlider.addTarget(self, action: #selector(printVal(_:)), for: .valueChanged)
        
        backgroundView.addSubview(multiSlider)
    }
    
    @objc func printVal(_ control: MultiSlider) {
        //print("Lower: \(control.lowerValue) Upper: \(control.upperValue)")
    }
}

