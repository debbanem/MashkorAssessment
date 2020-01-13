//
//  ViewController.swift
//  Mashkor
//
//  Created by Mark Debbane on 1/7/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    var mapManager: MapManager!
    var markers: [GMSMarker] = []
    var likelyPlaces: [GMSPlace] = []
    var locationManager: LocationManager!
    var longPressRecognizer = UILongPressGestureRecognizer()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placesBtn: UIButton!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = LocationManager(self)
        self.mapManager = MapManager(self.mapView, delegate: self)
        self.initUI()

    }
    

    @IBAction func addBtnPressed(_ sender: Any) {
        
        if self.markers.count < 2 {
            
            self.markers.append(self.mapManager.addMarker())
            self.addBtn.isEnabled = true
            
        }
        else{
            
            self.addBtn.isEnabled = false
            
        }
        
        self.updateDistance()
    }
    
    @IBAction func clearMap(_ sender: Any) {

        self.addBtn.isEnabled = true
        self.distanceLabel.isHidden = true
        
        if let currentLocation = self.locationManager.currentLocation {
            
            self.mapManager.clearMapContent(currentLocation)

        }
    }
    
    func initUI(){
        self.listLikelyPlaces()
        self.stylePlacesButton()
        self.navigationController?.navigationBar.barStyle = .black


    }
    func stylePlacesButton() {
        
        self.placesBtn.layer.shadowRadius = 10.0
        self.placesBtn.layer.shadowOpacity = 0.6
        self.placesBtn.layer.masksToBounds = false
        self.placesBtn.layer.shadowOffset = CGSize(width: 0, height: 3)

    }
    
    func updateDistance(){
        
        if self.markers.count == 2 {
            
            if let fromMarker = self.markers.first, let toMarker = self.markers.last {
                
                let distance = self.mapManager.updatePath(fromMarker: fromMarker, toMarker: toMarker)
                
                self.setDistanceLabel(distance)
                
            }
        }
    }
    
    func setDistanceLabel(_ distance: CLLocationDistance) {
        
        self.distanceLabel.isHidden = false
        self.distanceLabel.text = "\(distance.rounded()) meters"
        
    }
    
    func listLikelyPlaces() {
        
        self.likelyPlaces.removeAll()
        self.likelyPlaces = self.locationManager.getLikelyPlaces()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDistance" {
            
            if let destinationVC = segue.destination as? PlacesViewController {
                
                destinationVC.delegate = self
                
            }
        }
    }
}

extension MapViewController : UIGestureRecognizerDelegate
{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

