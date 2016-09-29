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
    func test_linear()
    {
        let easingCurve = EasingCurve.linear
        
        XCTAssertEquals(easingCurve.function(0), 0)
    }
    
    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
