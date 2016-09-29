//
//  PoltView.swift
//  Easing
//
//  Created by Christian Otkjær on 23/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

class PlotView: UIView
{
    var functions = Array<(UIColor, (Double)->Double)>()
    
    override func draw(_ rect: CGRect)
    {
        let length = Double(min(bounds.width, bounds.height))
        let width = 2 * Double(length) / 3
        let offset = CGPoint(x: (bounds.width - CGFloat(width)) / 2, y: (bounds.height - CGFloat(width)) / 2)
        
        UIColor(white: 0.95, alpha: 1).setFill()
        
        UIBezierPath(rect: CGRect(origin: offset, size: CGSize(width: width, height: width))).fill()

        for (color, function) in functions
        {
            var values = Array<Double>()
            
            for t in stride(from: Double(0), through: width, by: 1)
            {
                values.append(function(t/width))
            }
            
//            let maxF = values.reduce(-Double.infinity, combine: { max($0, $1) })
//            let minF = values.reduce(Double.infinity, combine: { min($0, $1) })
            
//            let height = width / (maxF - minF)
            
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: offset.x + 0, y: offset.y + CGFloat((1 - values[0]) * width)))
            
            for (i, v) in values.enumerated()
            {
                path.addLine(to: CGPoint(x: offset.x + CGFloat(i), y: offset.y + CGFloat((1 - v) * width)))
            }
            
            path.lineWidth = 1
            color.setStroke()
            
            path.stroke()
        }
    }
}
