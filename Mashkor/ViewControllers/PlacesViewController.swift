//
//  PlacesViewController.swift
//  Mashkor
//
//  Created by Mark Debbane on 1/7/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class PlacesViewController: UIViewController {
    
    @IBOutlet weak var fromSearchView: UIView!
    @IBOutlet weak var toSearchView: UIView!
    
    @IBOutlet weak var fromSelected: UILabel!
    @IBOutlet weak var toSelected: UILabel!
    
    @IBOutlet weak var fromStackView: UIStackView!
    @IBOutlet weak var toStackView: UIStackView!
    @IBOutlet weak var fromSearchViewYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var toSearchViewYConstraint: NSLayoutConstraint!
    var delegate: isAbleToReceiveData!
    
    
    var fromResultsViewController: GMSAutocompleteResultsViewController?
    var toResultsViewController: GMSAutocompleteResultsViewController?
    
    
    var fromSearchController: UISearchController?
    var toSearchController: UISearchController?
    
    var fromResultView: UITextView?
    var toResultView: UITextView?
    
    weak var fromSearchBar: UISearchBar!
    weak var toSearchBar: UISearchBar!
    
    
    var fromActive: Bool = false
    var toActive: Bool = false
    
    var fromPlace: GMSPlace!
    var toPlace: GMSPlace!
    
    var selectedPlaces: [String: GMSPlace] = [:]
    var confirmPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchControllers()
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        confirmPressed = true
        returnToMap()
        
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        returnToMap()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if selectedPlaces.count == 2 && confirmPressed {
            delegate.pass(data: selectedPlaces)
        }
        
    }
    
    
    func setupSearchControllers() {
        setUpFromSearchController()
        setUpToSearchController()
        
    }
    
    func setUpFromSearchController() {
        
        fromResultsViewController = GMSAutocompleteResultsViewController()
        fromSearchController = UISearchController(searchResultsController: fromResultsViewController)
        
        if let results = fromResultsViewController, let search = fromSearchController {
            
            initSearchController(resultsViewController: results, searchController: search)
            
        }
        
        if let fromSubView = fromSearchView, let searchBar = fromSearchController?.searchBar {
            fromSearchBar = searchBar
            fromSearchBar.tintColor = .green
            
            fromSubView.addSubview(fromSearchBar)
            view.addSubview(fromSubView)
        }
        fromSearchBar.tag = 0
        fromSearchBar.placeholder = "From"
        
    }
    
    func setUpToSearchController() {
        
        toResultsViewController = GMSAutocompleteResultsViewController()
        toSearchController = UISearchController(searchResultsController: toResultsViewController)
        
        
        if let results = toResultsViewController, let search = toSearchController {
            
            initSearchController(resultsViewController: results, searchController: search)
            
        }
        
        if let toSubView = toSearchView, let searchBar = toSearchController?.searchBar {
            toSearchBar = searchBar
            toSearchBar.tintColor = .green
            
            toSubView.addSubview(toSearchBar)
            view.addSubview(toSubView)
        }
        toSearchBar.tag = 1
        toSearchBar.placeholder = "To"
    }
    
    func initSearchController(resultsViewController: GMSAutocompleteResultsViewController, searchController: UISearchController){
        
        resultsViewController.delegate = self
        resultsViewController.style()
        
        searchController.searchResultsUpdater = resultsViewController
        
        searchController.view.backgroundColor = .dark
        
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.barTintColor = .dark
        //        searchController.searchBar.backgroundColor = .dark
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        
        
    }
    
}


extension PlacesViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.tag == 0 {
            fromActive = true
            toActive = false
            
        }
        else {
            toActive = true
            fromActive = false
        }
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.tag == 0 {
            fromActive = true
            UIView.animate(withDuration: 0.3) {
                let screen = UIScreen.main.bounds
                self.fromSearchView.frame = CGRect(x: self.fromSearchView.frame.origin.x, y: screen.minY, width: self.fromSearchView.frame.width, height: self.fromSearchView.frame.height)
            }
        }
        else {
            toActive = true
            UIView.animate(withDuration: 0.3) {
                let screen = UIScreen.main.bounds
                self.toSearchView.frame = CGRect(x: self.toSearchView.frame.origin.x, y: screen.minY, width: self.toSearchView.frame.width, height: self.toSearchView.frame.height)
            }
            
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar.tag == 0 {
            fromActive = false
            UIView.animate(withDuration: 0.3) {
                self.fromSearchView.frame = CGRect(x: self.fromSearchView.frame.origin.x, y: self.fromSearchViewYConstraint.constant, width: self.fromSearchView.frame.width, height: self.fromSearchView.frame.height)
            }
        }
        else {
            toActive = false
            UIView.animate(withDuration: 0.3) {
                self.toSearchView.frame = CGRect(x: self.toSearchView.frame.origin.x, y: self.toSearchViewYConstraint.constant, width: self.toSearchView.frame.width, height: self.toSearchView.frame.height)
            }
        }
    }
    
}

extension PlacesViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    
}

// Handle the user's selection.
extension PlacesViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        if fromActive {
            fromSelected.text = place.formattedAddress
            fromSearchController?.isActive = false
            fromPlace = place
            selectedPlaces["From"] = fromPlace
        }
            
        else if toActive {
            toSelected.text = place.formattedAddress
            toSearchController?.isActive = false
            toPlace = place
            selectedPlaces["To"] = toPlace
            
        }
        
    }
    
    
    func returnToMap(){
        self.presentingViewController?.dismiss(animated: true, completion: {
        })
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    }
}


extension GMSAutocompleteResultsViewController {
    func style(){
        let tableView = self.view.subviews.first as! UITableView
        tableView.backgroundColor = .dark
        self.tableCellBackgroundColor = .dark
        self.view.backgroundColor = .dark
        tableView.keyboardDismissMode = .interactive
    }
    
}
