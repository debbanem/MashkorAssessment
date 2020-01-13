//
//  Protocols.swift
//  Mashkor
//
//  Created by Mark Debbane on 1/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

/**
   
Allows Passing chosen locations from Places Controller to Map Contoller

*/
protocol isAbleToReceiveData {
    func pass(data: [String: GMSPlace])
}

extension MapViewController:isAbleToReceiveData{
    /**
            - Adds Chosen Places to Map
            - Creates markers for each location
            - Updates map path
            - Sets new distance
            - parameter data: Dictionary of `String` (key) : `GMSPlace`(value) representing from and to locations
     */
    func pass(data: [String: GMSPlace]) {
        if let fromPlace = data["From"], let toPlace = data["To"] {
            
            let fromMarker: GMSMarker = mapManager.formatMarker(fromPlace)
            let toMarker: GMSMarker = mapManager.formatMarker(toPlace)
            
            let distance = mapManager.updatePath(fromMarker: fromMarker, toMarker: toMarker)
            self.setDistanceLabel(distance)
        }
        
        
    }
    
}
