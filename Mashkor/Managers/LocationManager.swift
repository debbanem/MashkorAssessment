//
//  LocationManager.swift
//  Mashkor
//
//  Created by Mark Debbane on 1/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

/**
   
Map Location Handling


   Fields
   - zoomLevel: `Float`Standardized zoom level (`15.0`)
   - locationManager: `CLLocationManager`
   - defaultLocation: `CLLocation` fallback location in case user location tracking disallowed
   - currentLocation:  `CLLocation`  user location in case user location tracking allowed
   - placesClient: `GMSPlacesClient` handles `GMSPlaces`

*/
class LocationManager {
    
    let zoomLevel: Float = 15.0
    let locationManager = CLLocationManager()
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!

    
    init(_ vc: CLLocationManagerDelegate) {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = vc
        
        self.currentLocation = locationManager.location
        self.placesClient = GMSPlacesClient.shared()
        
    }
    /**
     
     - Gets Nearby LikelyPlaces in order to fill map
     - returns: Array of `GMSPlace` representing likely nearby places
    */
    func getLikelyPlaces() -> [GMSPlace]{
        var likelyPlaces: [GMSPlace] = []
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    likelyPlaces.append(place)
                }
            }
        })
        
        return likelyPlaces
    }
    
    
}

// Delegates to handle events for the location manager.
extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last
            else {
                return
        }
        print("Location: \(location)")
        
        if let manager = self.locationManager {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: manager.zoomLevel)
            
            if self.mapView.isHidden {
                self.mapView.isHidden = false
                self.mapView.camera = camera
            } else {
                self.mapView.animate(to: camera)
            }
            
            self.listLikelyPlaces()
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            self.mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
