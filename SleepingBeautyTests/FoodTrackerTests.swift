//
//  SleepingBeautyTests.swift
//  SleepingBeautyTests
//
//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import XCTest
@testable import SleepingBeauty

class SleepingBeautyTests: XCTestCase {
    
    //MARK: Sleep Class Tests
    
    // Confirm that the Sleep initializer returns a Sleep object when passed valid parameters.
    func testSleepInitializationSucceeds() {
        
        // Zero rating
        let zeroRatingSleep = Sleep.init(hoursOverUnder: "0", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingSleep)

        // Positive rating
        let positiveRatingSleep = Sleep.init(hoursOverUnder: "1", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingSleep)

    }
    
    // Confirm that the Sleep initialier returns nil when passed a negative rating or an empty hoursOverUnder.
    func testSleepInitializationFails() {
        
        // Negative rating
        let negativeRatingSleep = Sleep.init(hoursOverUnder: "-1", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingSleep)
        
        // Rating exceeds maximum
        let largeRatingSleep = Sleep.init(hoursOverUnder: "5", photo: nil, rating: 6)
        XCTAssertNil(largeRatingSleep)

        // Empty String
        let emptyStringSleep = Sleep.init(hoursOverUnder: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringSleep)
        
    }
}
