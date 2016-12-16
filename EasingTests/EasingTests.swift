//
//  EasingTests.swift
//  EasingTests
//
//  Created by Christian Otkjær on 18/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Easing

class EasingTests: XCTestCase
{
    func test_ends()
    {
        for easingCurve : EasingCurve in [.linear, .sine, .bounce, .circular, .cubic, .elastic]
        {
            XCTAssertEqualWithAccuracy(easingCurve.function(0), 0, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(easingCurve.function(1), 1, accuracy: 0.0001)
        }
    }
}
