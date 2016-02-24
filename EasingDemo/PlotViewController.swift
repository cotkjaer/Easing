//
//  PlotViewController.swift
//  Easing
//
//  Created by Christian Otkjær on 23/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Easing

class PlotViewController: UIViewController
{
    @IBOutlet weak var plotView: PlotView?
    
    var timingFunction = TimingFunction()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    let curves : Array<EasingCurve> =
    [
        .Linear, // 0
        .Quadratic,
        .Cubic,
        .Quartic,
        .Quintic,
        .Sine, // 5
        .Circular,
        .Exponential,
        .OvershootingCubic,
        .Elastic,
        .Bounce
    ]
    
    func handleChange(index: Int, @noescape closure: (EasingCurve?)->())
    {
        if index < 0 || index >= curves.count
        {
            closure(nil)
        }
        else
        {
            closure(curves[index])
        }
        
        let color = view.tintColor
        
        updatePlot(false, color: color, function: timingFunction.function)
        
        updatePlot(true, color: color, function: timingFunction.function)
    }
    
    @IBAction func handleEaseInChange(sender: UISegmentedControl)
    {
        handleChange(sender.selectedSegmentIndex) {
            timingFunction.easeIn = $0
        }
    }
    
    
    @IBAction func handleEaseOutChange(sender: UISegmentedControl)
    {
        handleChange(sender.selectedSegmentIndex) {
            timingFunction.easeOut = $0
        }
    }
    
    
    @IBAction func handleButton(button: UIButton)
    {
        button.selected = !button.selected
        
        timingFunction.easeIn = curves[button.tag]
    
        let color = button.tintColor

        updatePlot(button.selected, color: color, function: timingFunction.function)
    }
    
    func updatePlot(add: Bool, color: UIColor, function: Double->Double)
    {
        if add
        {
            plotView?.functions.append((color, function))
        }
        else if let index = plotView?.functions.indexOf({ $0.0 == color })
        {
            plotView?.functions.removeAtIndex(index)
        }
        
        plotView?.setNeedsDisplay()
    }
}
