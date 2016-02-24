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
    case Linear
    case Quadratic
    case Cubic
    case Quartic
    case Quintic
    case Sine
    case Circular
    case Exponential
    case Elastic
    case OvershootingCubic
    case Bounce
    case Custom(Double -> Double)
    
    var function : Double -> Double
        {
            switch self
            {
            case .Linear:
                return { $0 }
                
            case .Quadratic:
                return { $0 * $0 }
                
            case .Cubic:
                return { $0 * $0 * $0 }
                
            case .Quartic:
                return { $0 * $0 * $0 * $0 }
                
            case .Quintic:
                return { $0 * $0 * $0 * $0 * $0 }
                
            case .Sine:
                return { 1 - sin(π_11_8 + $0 * π_5_8) / sin_π_11_8 }
                
            case .Circular:
                return { 1 - sqrt(1 - $0 * $0) }
                
            case .Exponential:
                return { $0 == 0 ? $0 : pow(2, 10 * ($0 - 1)) }
                
            case .Elastic:
                return { sin(π_13_2 * $0) * pow(2, 10 * ($0 - 1)) }

            case .Bounce:
                return { abs (-(sin(π_13_2 * $0) * pow(2, 10 * ($0 - 1)))) }
                
            case .OvershootingCubic:
                return { $0 * $0 * $0 - $0 * sin($0 * π) }
                
            case .Custom(let f):
                return f
            }
            
            
    }
}

public enum EasingMode
{
    case EaseIn
    case EaseOut
    case EaseInOut
    
    func functionForCurve(curve: EasingCurve) -> (Double -> Double)
    {
        switch self
        {
        case .EaseIn:
            return curve.function
            
        case .EaseOut:
            return { 1 - curve.function(1 - $0) }
            
        case .EaseInOut:
            return
                {
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
    
    public var function : Double -> Double
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
            
            return EasingCurve.Linear.function
            
            //        return mode.functionForCurve(curve)
    }
}
/*

private let π : CGFloat = 3.1415926535897932384626433832795028841971693993751058209749445923078164062

private let π_2 : CGFloat = π / 2
private let π_4 : CGFloat = π / 4



//  Based on: easing.c
//
//  Copyright (c) 2011, Auerhaus Development, LLC
//
//  This program is free software. It comes without any warranty, to
//  the extent permitted by applicable law. You can redistribute it
//  and/or modify it under the terms of the Do What The Fuck You Want
//  To Public License, Version 2, as published by Sam Hocevar. See
//  http://sam.zoy.org/wtfpl/COPYING for more details.
//

// Modeled after the line y = x
public func LinearInterpolation(p: CGFloat) -> CGFloat
{
return p
}

// Modeled after the parabola y = x^2
public func QuadraticEaseIn(p: CGFloat) -> CGFloat
{
return p * p
}

// Modeled after the parabola y = -x^2 + 2x
public func QuadraticEaseOut(p: CGFloat) -> CGFloat
{
return -(p * (p - 2))
}

// Modeled after the piecewise quadratic
// y = (1/2)((2x)^2)              [0, 0.5)
// y = -(1/2)((2x-1)*(2x-3) - 1)  [0.5, 1]
public func QuadraticEaseInOut(p: CGFloat) -> CGFloat
{
if(p < 0.5)
{
return 2 * p * p
}
else
{
return (-2 * p * p) + (4 * p) - 1
}
}

// Modeled after the cubic y = x^3
public func CubicEaseIn(p: CGFloat) -> CGFloat
{
return p * p * p
}

// Modeled after the cubic y = (x - 1)^3 + 1
public func CubicEaseOut(p: CGFloat) -> CGFloat
{
let f = (p - 1)
return f * f * f + 1
}

// Modeled after the piecewise cubic
// y = (1/2)((2x)^3)        [0, 0.5)
// y = (1/2)((2x-2)^3 + 2)  [0.5, 1]
public func CubicEaseInOut(p: CGFloat) -> CGFloat
{
if(p < 0.5)
{
return 4 * p * p * p
}
else
{
let f = ((2 * p) - 2)
return 0.5 * f * f * f + 1
}
}

// Modeled after the quartic x^4
public func QuarticEaseIn(p: CGFloat) -> CGFloat
{
return p * p * p * p
}

// Modeled after the quartic y = 1 - (x - 1)^4
public func QuarticEaseOut(p: CGFloat) -> CGFloat
{
let f = (p - 1)
return f * f * f * (1 - p) + 1
}

// Modeled after the piecewise quartic
// y = (1/2)((2x)^4)         [0, 0.5)
// y = -(1/2)((2x-2)^4 - 2)  [0.5, 1]
public func QuarticEaseInOut(p: CGFloat) -> CGFloat
{
if(p < 0.5)
{
return 8 * p * p * p * p
}
else
{
let f = (p - 1)
return -8 * f * f * f * f + 1
}
}

// Modeled after the quintic y = x^5
public func QuinticEaseIn(p: CGFloat) -> CGFloat
{
return p * p * p * p * p
}

// Modeled after the quintic y = (x - 1)^5 + 1
public func QuinticEaseOut(p: CGFloat) -> CGFloat
{
let f = (p - 1)
return f * f * f * f * f + 1
}

// Modeled after the piecewise quintic
// y = (1/2)((2x)^5)        [0, 0.5)
// y = (1/2)((2x-2)^5 + 2)  [0.5, 1]
public func QuinticEaseInOut(p: CGFloat) -> CGFloat
{
if(p < 0.5)
{
return 16 * p * p * p * p * p
}
else
{
let f = ((2 * p) - 2)
return  0.5 * f * f * f * f * f + 1
}
}

// Modeled after quarter-cycle of sine wave
public func SineEaseIn(p: CGFloat) -> CGFloat
{
return sin((p - 1) * π_2) + 1
}

// Modeled after quarter-cycle of sine wave (different phase)
public func SineEaseOut(p: CGFloat) -> CGFloat
{
return sin(p * π_2)
}

// Modeled after half sine wave
public func SineEaseInOut(p: CGFloat) -> CGFloat
{
return 0.5 * (1 - cos(p * π))
}

// Modeled after shifted quadrant IV of unit circle
public func CircularEaseIn(p: CGFloat) -> CGFloat
{
return 1 - sqrt(1 - (p * p))
}

// Modeled after shifted quadrant II of unit circle
public func CircularEaseOut(p: CGFloat) -> CGFloat
{
return sqrt((2 - p) * p)
}

// Modeled after the piecewise circular function
// y = (1/2)(1 - sqrt(1 - 4x^2))            [0, 0.5)
// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1)  [0.5, 1]
public func CircularEaseInOut(p: CGFloat) -> CGFloat
{
if(p < 0.5)
{
return 0.5 * (1 - sqrt(1 - 4 * (p * p)))
}
else
{
return 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1)
}
}

// Modeled after the exponential function y = 2^(10(x - 1))
public func ExponentialEaseIn(p: CGFloat) -> CGFloat
{
return (p == 0.0) ? p : pow(2, 10 * (p - 1))
}

// Modeled after the exponential function y = -2^(-10x) + 1
public func ExponentialEaseOut(p: CGFloat) -> CGFloat
{
return (p == 1.0) ? p : 1 - pow(2, -10 * p)
}

// Modeled after the piecewise exponential
// y = (1/2)2^(10(2x - 1))          [0,0.5)
// y = -(1/2)*2^(-10(2x - 1))) + 1  [0.5,1]
public func ExponentialEaseInOut(p: CGFloat) -> CGFloat
{
if(p == 0.0 || p == 1.0) { return p }

if(p < 0.5)
{
return 0.5 * pow(2, (20 * p) - 10)
}
else
{
return -0.5 * pow(2, (-20 * p) + 10) + 1
}
}

// Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
public func ElasticEaseIn(p: CGFloat) -> CGFloat
{
return sin(13 * π_2 * p) * pow(2, 10 * (p - 1))
}

// Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
public func ElasticEaseOut(p: CGFloat) -> CGFloat
{
return sin(-13 * π_2 * (p + 1)) * pow(2, -10 * p) + 1
}

// Modeled after the piecewise exponentially-damped sine wave:
// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))       [0,0.5)
// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2)  [0.5, 1]
public func ElasticEaseInOut(p: CGFloat) -> CGFloat
{
if(p < 0.5)
{
return 0.5 * sin(13 * π_2 * (2 * p)) * pow(2, 10 * ((2 * p) - 1))
}
else
{
return 0.5 * (sin(-13 * π_2 * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2)
}
}

// Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
public func BackEaseIn(p: CGFloat) -> CGFloat
{
return p * p * p - p * sin(p * π)
}

// Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
public func BackEaseOut(p: CGFloat) -> CGFloat
{
let f = (1 - p)
let f3 = f * f * f
return 1 - (f3 - f * sin(f * π))
}

// Modeled after the piecewise overshooting cubic function:
// y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))            [0, 0.5)
// y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1)  [0.5, 1]
public func BackEaseInOut(p: CGFloat) -> CGFloat
{
if(p < 0.5)
{
let f = 2 * p
return 0.5 * f * (f * f - sin(f * π))
}
else
{
let f = (1 - (2 * p - 1))
let fMark = f * (f * f - sin(f * π))
return 0.5 * (1 - fMark) + 0.5
}
}

public func BounceEaseIn(p: CGFloat) -> CGFloat
{
return 1 - BounceEaseOut(1 - p)
}

public func BounceEaseOut(p: CGFloat) -> CGFloat
{
if(p < 4/11.0)
{
return (121 * p * p)/16.0
}
else if(p < 8/11.0)
{
return (363/40.0 * p * p) - (99/10.0 * p) + 17/5.0
}
else if(p < 9/10.0)
{
return (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0
}
else
{
return (54/5.0 * p * p) - (513/25.0 * p) + 268/25.0
}
}

public func BounceEaseInOut(p: CGFloat) -> CGFloat
{
if(p < 0.5)
{
return 0.5 * BounceEaseIn(p*2)
}
else
{
return 0.5 * BounceEaseOut(p * 2 - 1) + 0.5
}
}
*/