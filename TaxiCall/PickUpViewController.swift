//
//  PickUpViewController.swift
//  TaxiCall
//
//  Created by YU on 2018/10/16.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit
import MapKit

class PickUpViewController: UIViewController,MKMapViewDelegate {
    
    var riderEmail = ""
    var riderLocation = CLLocationCoordinate2D()
    var driverLocation = CLLocationCoordinate2D()

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func pickUpRequest(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 0.0018, longitudeDelta: 0.0018)
        let region = MKCoordinateRegion(center: riderLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = riderLocation
        annotation.title = riderEmail
        mapView.addAnnotation(annotation)
    }

}
