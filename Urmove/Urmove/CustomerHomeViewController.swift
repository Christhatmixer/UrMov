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
let mapStyle = "https://maps.googleapis.com/maps/api/staticmap?key=AIzaSyALoLhshrdNCqCEmOZvD-SfMmmMH7VVGe8&center=-33.87221166880314,151.14313354492182&zoom=11&format=png&maptype=roadmap&style=element:geometry%7Ccolor:0x212121&style=element:labels.icon%7Cvisibility:off&style=element:labels.text.fill%7Ccolor:0x757575&style=element:labels.text.stroke%7Ccolor:0x212121&style=feature:administrative%7Celement:geometry%7Ccolor:0x757575&style=feature:administrative.country%7Celement:labels.text.fill%7Ccolor:0x9e9e9e&style=feature:administrative.land_parcel%7Cvisibility:off&style=feature:administrative.locality%7Celement:labels.text.fill%7Ccolor:0xbdbdbd&style=feature:poi%7Celement:labels.text.fill%7Ccolor:0x757575&style=feature:poi.park%7Celement:geometry%7Ccolor:0x181818&style=feature:poi.park%7Celement:labels.text.fill%7Ccolor:0x616161&style=feature:poi.park%7Celement:labels.text.stroke%7Ccolor:0x1b1b1b&style=feature:road%7Celement:geometry.fill%7Ccolor:0x2c2c2c&style=feature:road%7Celement:labels.text.fill%7Ccolor:0x8a8a8a&style=feature:road.arterial%7Celement:geometry%7Ccolor:0x373737&style=feature:road.highway%7Celement:geometry%7Ccolor:0x3c3c3c&style=feature:road.highway.controlled_access%7Celement:geometry%7Ccolor:0x4e4e4e&style=feature:road.local%7Celement:labels.text.fill%7Ccolor:0x616161&style=feature:transit%7Celement:labels.text.fill%7Ccolor:0x757575&style=feature:water%7Celement:geometry%7Ccolor:0x000000&style=feature:water%7Celement:labels.text.fill%7Ccolor:0x3d3d3d&size=480x360"
class CustomerHomeViewController: UIViewController,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate,GMSMapViewDelegate  {
    var userData = customer()
    var userLocation: CLLocation?
    var locationManager: CLLocationManager = CLLocationManager()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var newGasRequest = gasRequest()
    let marker = GMSMarker()
    let geoCoder = GMSGeocoder()
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestLocation()
        
        userLocation = locationManager.location
        
        let userLat = userLocation?.coordinate.latitude
        let userLong = userLocation?.coordinate.longitude
        //let camera = GMSCameraPosition.camera(withTarget: Double(userLat!), zoom: 15.0, bearing: Double(userLong!), viewingAngle: 45)
        let camera = GMSCameraPosition.camera(withLatitude: Double(userLat!), longitude: Double(userLong!), zoom: 15.0, bearing: 0, viewingAngle: 45)
        mapView.delegate = self
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
            
        } else {
            print("User's location is unknown")
        }
        
        marker.position = CLLocationCoordinate2D(latitude: userLat!, longitude: userLong!)
        marker.map = mapView
        marker.isDraggable = true
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json"){
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }else{
                print("unable to find style file")
            }
            
            
        } catch {
            print("failed to load style")
        }

        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        marker.position = position.target
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        marker.position = position.target
        geoCoder.reverseGeocodeCoordinate(marker.position) { (response, error) in
            if let error = error{
                print(error)
            }else{
                print(response?.firstResult()?.lines![0])
                self.addressLabel.text = response?.firstResult()?.addressLine1()
            }
        }
        print(marker.position)
    }
    @IBAction func addressSearchButtonFunction(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.tableCellBackgroundColor = UIColor(displayP3Red: 40.0/250, green: 39.0/250, blue: 46.0/250, alpha: 1.0)
        autocompleteController.primaryTextColor = UIColor(displayP3Red: 243.0/250, green: 245.0/250, blue: 246.0/250, alpha: 1.0)
        autocompleteController.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 40.0/250, green: 39.0/250, blue: 46.0/250, alpha: 1.0)
        autocompleteController.navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 40.0/250, green: 39.0/250, blue: 46.0/250, alpha: 1.0)
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        addressLabel.text = place.formattedAddress
        marker.position = place.coordinate
        let cameraUpdate = GMSCameraUpdate.setTarget(place.coordinate)
        self.mapView.moveCamera(cameraUpdate)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
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

