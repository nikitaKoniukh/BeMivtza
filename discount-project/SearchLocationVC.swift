//
//  SearchLocationVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 16/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import MapKit
import Contacts

protocol GetNameStoreDelegate {
    func getStoreNameAndAddress(storeName: String, storeAddress: String)
}

protocol getCoordinatesDelegate{
    func getCoordinates(latitude: Double, longitude: Double)
}

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark, storeAddress: String)
}

class SearchLocationVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //Variables
    var matchingItems: [MKMapItem] = []
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var getNameDelegate: GetNameStoreDelegate?
    var getCoordinatesDelegate: getCoordinatesDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupSearchController()
        
    }
    
    func setupLocationManager(){
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined{
            let alert = UIAlertController(title: "האם ברצונך לספק גישה למיקום הגיאוגרפי שלך?", message: "אנחנו רוצים להראות לך את ההצעות החמות ביותר בקרבתך!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "כן, בטח!", style: .default, handler: { (_) in
                self.locationManager.requestWhenInUseAuthorization()
            }))
            alert.addAction(UIAlertAction(title: "לא", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupSearchController(){
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "locationSearchTableView") as! LocationSearchTableView
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable 
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "חפש מקומות"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }

}

extension SearchLocationVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension SearchLocationVC: HandleMapSearch {
    
    func dropPinZoomIn(placemark:MKPlacemark, storeAddress: String){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name

        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        getNameDelegate?.getStoreNameAndAddress(storeName: annotation.title ?? "store name", storeAddress: storeAddress)
        
        let latitude = placemark.coordinate.latitude
        let longitude = placemark.coordinate.longitude
        getCoordinatesDelegate?.getCoordinates(latitude: latitude, longitude: longitude)
        
        navigationController?.popViewController(animated: true)
    }
}
