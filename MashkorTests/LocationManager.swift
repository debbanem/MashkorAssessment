//
//  LocationManager.swift
//  MashkorTests
//
//  Created by Mark Debbane on 1/7/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import XCTest
@testable import Mashkor

class LocationManagerTests: XCTestCase {
    var manager: LocationManager?
 
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        manager = LocationManager(MapViewController())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        manager = nil
    }

    func testlikePlaces() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let likePlaces = manager?.getLikelyPlaces()
        XCTAssertNotNil(likePlaces?.count)
    }
    
    func testCurrentLocation(){
        XCTAssertNotNil(manager?.currentLocation)
    }


}
