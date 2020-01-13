//
//  MapManager.swift
//  Mashkor
//
//  Created by Mark Debbane on 1/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
import UIKit

/**
    
 Handles all the changes that might occur on a `GMSMapView`
 
 
    Fields
    - screen: Device screen size
    - mapView: `GMSMapView` (Main map view)
    - polyline: `GMSPolyline` (Colored line displayed on map) representing the path between 2 points of places
    - path:  `GMSMutablePath`  of which the distance will be calculated and displayed
    - likelyPlaces: Array of `GMSPlaces` that are around the user's location
 
 */
class MapManager {
    
    
    let screen = UIScreen.main.bounds
    var mapView: GMSMapView!
    var polyline: GMSPolyline?
    var path: GMSMutablePath?
    var likelyPlaces: [GMSPlace] = []


    init(_ mapView: GMSMapView, delegate:  GMSMapViewDelegate ) {
        self.mapView = mapView
        self.mapView.settings.myLocationButton = true
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true
        self.mapView.delegate = delegate
    }
    /**
     
     - Clears map marker layer
     - Resets to user current location
     - Sets polyline.map to nil
     - Sets path to nil
     - parameter currentLocation: User's current location (if allowed) or default location (if not allowed)
    */
    


    func clearMapContent(_ currentLocation: CLLocation){
        self.mapView.clear()
        self.mapView.moveCamera(GMSCameraUpdate.setTarget(currentLocation.coordinate))
        self.polyline?.map = nil
        self.path = nil
    }
    
    /**
        
        - Adds marker to map marker layer in center of map view frame
        - Enables marker to be draggable
        - Sets marker.map to current map
        - returns:Newly formatted `GMSMarker`
     
       */
       
    func addMarker() -> GMSMarker{
        let newMarker = GMSMarker(position: self.mapView.projection.coordinate(for: CGPoint(x: self.screen.midX, y: self.screen.midY)))
        newMarker.isDraggable = true
        newMarker.map = mapView
        
        return newMarker
    }
    
    
    
    /**
        
        - Sets `GMSMarker` title to `GMSPlace` Title
        - Sets `GMSMarker` snippet to `GMSPlace` formattedAddress
        - Sets` GMSMarker` icon
        - Sets `GMSMarker` position to `GMSPlace` coordinates
        - parameter place: `GMSPlace` representing the coordinates of the marker being created
        - returns: `GMSMarker` that was added to map after formatting is completed
     */
    func formatMarker(_ place: GMSPlace) -> GMSMarker{
        let marker: GMSMarker = GMSMarker() // Allocating Marker
        
        marker.title = "\(place.name ?? "")" // Setting title
        marker.snippet = "\(place.formattedAddress ?? "")" // Setting sub title
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.appearAnimation = .pop // Appearing animation. default
        marker.position = place.coordinate
        
        DispatchQueue.main.async { // Setting marker on mapview in main thread.
            marker.map = self.mapView // Setting marker on Mapview
            
        }
        return marker
    }
    /**
           
           Updates path to a new path calculated from parameters.
           - Adds markers to new path
           - Draws new line based on new path
           - Calculates length of new path
           - parameter fromMarker: `GMSMarker` representing start of path
           - parameter toMarker: `GMSMarker` representing end of path
           - returns: `CLLLocationDistance` representing distance between the two markers
          */
    func updatePath(fromMarker: GMSMarker, toMarker: GMSMarker) -> CLLocationDistance{
        self.path = GMSMutablePath()
        self.path?.add(fromMarker.position)
        self.path?.add(toMarker.position)
        
        let coordinate0 = CLLocation(latitude: (fromMarker.position.latitude), longitude: (fromMarker.position.longitude))
        let coordinate1 = CLLocation(latitude: (toMarker.position.latitude), longitude: (toMarker.position.longitude))
        
        self.polyline?.map = nil

        self.polyline = GMSPolyline(path: path)
        self.polyline?.strokeWidth = 5
        self.polyline?.strokeColor = .red
        self.polyline?.map = mapView
        
        if let path = self.path {
            
            let bounds = GMSCoordinateBounds(path: (path))
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
            
        }
        return  coordinate0.distance(from: coordinate1)
    }
    
}


extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        for m in markers {
            if marker == m {
                m.position = marker.position
            }
        }
       self.updateDistance()
    }
}
