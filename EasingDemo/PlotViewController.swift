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
    
    let curves : Array<EasingCurve> =
    [
        .linear, // 0
        .quadratic,
        .cubic,
        .quartic,
        .quintic,
        .sine, // 5
        .circular,
        .exponential,
        .overshootingCubic,
        .elastic,
        .bounce
    ]
    
    func handleChange(_ index: Int, closure: (EasingCurve?)->())
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
        
        updatePlot(false, color: color!, function: timingFunction.function)
        
        updatePlot(true, color: color!, function: timingFunction.function)
    }
    
    @IBAction func handleEaseInChange(_ sender: UISegmentedControl)
    {
        handleChange(sender.selectedSegmentIndex) {
            timingFunction.easeIn = $0
        }
    }
    
    
    @IBAction func handleEaseOutChange(_ sender: UISegmentedControl)
    {
        handleChange(sender.selectedSegmentIndex) {
            timingFunction.easeOut = $0
        }
    }
    
    func updatePlot(_ add: Bool, color: UIColor, function: @escaping (Double)->Double)
    {
        if add
        {
            plotView?.functions.append((color, function))
        }
        else if let index = plotView?.functions.index(where: { $0.0 == color })
        {
            plotView?.functions.remove(at: index)
        }
        
        plotView?.setNeedsDisplay()
    }
}
