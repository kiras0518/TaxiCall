//
//  PickUpViewController.swift
//  TaxiCall
//
//  Created by YU on 2018/10/16.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class PickUpViewController: UIViewController,MKMapViewDelegate {
    
    var riderEmail = ""
    var riderLocation = CLLocationCoordinate2D()
    var driverLocation = CLLocationCoordinate2D()
    let reference = Database.database().reference()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func pickUpRequest(_ sender: UIButton) {
        
        reference.child("RiderRequests").queryOrdered(byChild: "email").queryEqual(toValue: riderEmail).observeSingleEvent(of: DataEventType.childAdded) { (DataSnapshot) in
            
            DataSnapshot.ref.updateChildValues(["driverLatitude" : self.driverLocation.latitude, "driverLongitude" : self.driverLocation.longitude])
            
            let riderCLLocation = CLLocation(latitude: self.riderLocation.latitude, longitude: self.riderLocation.longitude)
            
            CLGeocoder().reverseGeocodeLocation(riderCLLocation, completionHandler: { (clplacemarks, error) in
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    if let placemarks = clplacemarks {
                        
                        if placemarks.count > 0 {
                            
                            let placeMark = MKPlacemark(placemark: placemarks[0])
                            let mapItem = MKMapItem(placemark: placeMark)
                            mapItem.name = self.riderEmail
                            
                            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                            
                        }
                        
                    }
                }
                
            })
        }
        
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
