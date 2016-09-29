//
//  Timing.swift
//  Easing
//
//  Created by Christian Otkjær on 31/10/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

private let π = M_PI

private let π_13_2 = M_PI_2 * 13

private let π_1_8 = M_PI_4 / 2
private let π_5_8 = π_1_8 * 5
private let π_10_8 = π_1_8 * 10
private let π_11_8 = π_1_8 * 11
private let sin_π_5_8 = sin(π_5_8)
private let sin_π_11_8 = sin(π_11_8)

public enum EasingCurve
{
    case linear
    case quadratic
    case cubic
    case quartic
    case quintic
    case sine
    case circular
    case exponential
    case elastic
    case overshootingCubic
    case bounce
    case custom((Double) -> Double)
    
    var function : (Double) -> Double
    {
        switch self
        {
        case .linear:
            return { $0 }
            
        case .quadratic:
            return { $0 * $0 }
            
        case .cubic:
            return { $0 * $0 * $0 }
            
        case .quartic:
            return { $0 * $0 * $0 * $0 }
            
        case .quintic:
            return { $0 * $0 * $0 * $0 * $0 }
            
        case .sine:
            return { 1 - sin(π_11_8 + $0 * π_5_8) / sin_π_11_8 }
            
        case .circular:
            return { 1 - sqrt(1 - $0 * $0) }
            
        case .exponential:
            return { $0 == 0 ? $0 : pow(2, 10 * ($0 - 1)) }
            
        case .elastic:
            return { sin(π_13_2 * $0) * pow(2, 10 * ($0 - 1)) }
            
        case .bounce:
            return { abs (-(sin(π_13_2 * $0) * pow(2, 10 * ($0 - 1)))) }
            
        case .overshootingCubic:
            return { $0 * $0 * $0 - $0 * sin($0 * π) }
            
        case .custom(let f):
            return f
        }
    }
}

public enum EasingMode
{
    case easeIn
    case easeOut
    case easeInOut
    
    func functionForCurve(_ curve: EasingCurve) -> ((Double) -> Double)
    {
        switch self
        {
        case .easeIn:
            return curve.function
            
        case .easeOut:
            return { 1 - curve.function(1 - $0) }
            
        case .easeInOut:
            return {
                if $0 < 0.5
                {
                    return curve.function($0 * 2) / 2
                }
                else
                {
                    return (1 - curve.function((1 - $0) * 2)) / 2
                }
            }
        }
    }
}

public struct TimingFunction
{
    public var easeIn: EasingCurve?
    public var easeOut: EasingCurve?
    
    public init(easeIn: EasingCurve? = nil,
                easeOut: EasingCurve? = nil)
    {
        self.easeIn = easeIn
        self.easeOut = easeOut
    }
    
    public var function : (Double) -> Double
    {
        if let easeIn = easeIn
        {
            if let easeOut = easeOut
            {
                return
                    {
                        if $0 < 0.5
                        {
                            return easeIn.function($0 * 2) / 2
                        }
                        else
                        {
                            return 1 - easeOut.function((1 - $0) * 2) / 2
                        }
                }
            }
            
            return easeIn.function
        }
        
        if let easeOut = easeOut
        {
            return { 1 - easeOut.function(1 - $0) }
        }
        
        return EasingCurve.linear.function
    }
}
