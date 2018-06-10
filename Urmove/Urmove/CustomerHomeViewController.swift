//
//  CustomerHomeViewController.swift
//  Urmove
//
//  Created by Christian on 5/7/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import SnapKit
class CustomerHomeViewController: UIViewController,CLLocationManagerDelegate,GMSAutocompleteResultsViewControllerDelegate  {
    var userData = customer()
    var userLocation: CLLocation?
    var locationManager: CLLocationManager = CLLocationManager()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

  
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestLocation()
        
        userLocation = locationManager.location
        
        let userLat = userLocation?.coordinate.latitude
        let userLong = userLocation?.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: Double(userLat!), longitude: Double(userLong!), zoom: 10.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
            
        } else {
            print("User's location is unknown")
        }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: userLat!, longitude: userLong!)
        marker.map = mapView
        marker.isDraggable = true

        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

