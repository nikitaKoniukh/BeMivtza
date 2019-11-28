//
//  MapVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 15/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import MapKit
import Contacts
import Firebase

class MapVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var mapView: MKMapView!
 
    //Variables
    let regionRadius: CLLocationDistance = 1000
    var productsCollectionRef: CollectionReference!
    var locationManager:  CLLocationManager?
    let productService = ProductsService()
    var artworks: [StoreLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mapView.delegate = self
        loadInitialData()
        setupLocationManager()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.titleView = LogoSmall.instance.setLogo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInitialData()
        setupLocationManager()
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .notDetermined{
            let alert = UIAlertController(title: LocalizableEnum.Map.alertTitle.localized, message: LocalizableEnum.Map.alertMessage.localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizableEnum.Global.yesOfCourse.localized, style: .default, handler: { (_) in
                self.locationManager?.requestWhenInUseAuthorization()
            }))
            alert.addAction(UIAlertAction(title: LocalizableEnum.Global.no.localized, style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            activateLocationSevices()
        }
    }
    
    func activateLocationSevices(){
        locationManager?.startUpdatingLocation()
    }
    
    func loadInitialData() {
        var products:[ProductModel] = []
        Firestore.firestore()
            .collection(PRODUCT_LIST_REF)
            .getDocuments() { (snapshot, err) in
                if let err = err{
                    debugPrint(err.localizedDescription)
                }else{
                    products = self.productService.parseData(snapshot: snapshot)

                        for item in products{
                           let loation = item.storeLocation.coordinate
                            print(loation)
                            let title = item.storeName

                            let locationName = item.storeAddress
                            let locationInfo = StoreLocation(title: title!,
                                                             locationName: locationName!,
                                                             discipline: "",
                                                             coordinate: loation)
                            self.artworks.append(locationInfo)
                        }
                }
                self.mapView.addAnnotations(self.artworks)
        }
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StoreLocation else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! StoreLocation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
        
    }
}

extension MapVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            activateLocationSevices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            animatedZoom(zoomRegion: region, duration: 2)
            mapView.showsUserLocation = true
        }
    }
    
    func animatedZoom(zoomRegion:MKCoordinateRegion, duration:TimeInterval) {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.mapView.setRegion(zoomRegion, animated: true)
            self.locationManager!.stopUpdatingLocation()
        }, completion: nil)
    }
    
 
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

