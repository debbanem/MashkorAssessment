//
//  MapManager.swift
//  MashkorTests
//
//  Created by Mark Debbane on 1/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import XCTest
import GooglePlaces
import GoogleMaps
@testable import Mashkor

class MapManagerTests: XCTestCase {

    var manager: MapManager?
    
    override func setUp() {
        manager = MapManager(GMSMapView(), delegate: MapViewController())
    }

    override func tearDown() {
     
        manager = nil
    }

    func testMapClear() {
        XCTAssert(manager?.path == nil)
        XCTAssert(manager?.polyline?.map == nil)
        XCTAssert(manager?.likelyPlaces.count == 0)
        
    }
    
    func testAddMarker() {
        XCTAssertNotNil(manager?.addMarker())
        XCTAssert(manager?.addMarker().map == manager?.mapView)
    }

}
