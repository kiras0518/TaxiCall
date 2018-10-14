//
//  RiderViewController.swift
//  TaxiCall
//
//  Created by YU on 2018/10/15.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RiderViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManger = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonCall: UIButton!
    
    @IBAction func callTaxi(_ sender: UIButton) {
    }
    @IBAction func logOut(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        locationManger.delegate = self
        
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            locationManger.requestAlwaysAuthorization()
        }
        locationManger.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let cooridnate : CLLocationCoordinate2D = manager.location?.coordinate {
            
            let region = MKCoordinateRegion(center: cooridnate, span: MKCoordinateSpan(latitudeDelta: 0.018, longitudeDelta: 0.018))
            
            mapView.setRegion(region, animated: true)
            
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = cooridnate
            annotation.title = "My Location"
            mapView.addAnnotation(annotation)
            
        }
    }
   

}
