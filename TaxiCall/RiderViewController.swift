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
import FirebaseAuth
import FirebaseDatabase

class RiderViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManger = CLLocationManager()
    var HasBeenCalled = false
    var userLocation = CLLocationCoordinate2D()
    let reference : DatabaseReference = Database.database().reference()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonCall: UIButton!
    
    @IBAction func callTaxi(_ sender: UIButton) {
        
        if let email = Auth.auth().currentUser?.email {
        if HasBeenCalled {
            
            reference.child("RiderRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(DataEventType.childAdded) { (dataSnapShot) in
                dataSnapShot.ref.removeValue()
                self.reference.child("RiderRequests").removeAllObservers()
            }
            
            cancelTaixMode()
           
        } else {
            
            let riderRequestDic : [String : Any] = ["email": email, "latitude": userLocation.latitude, "longitude": userLocation.longitude]
            
            reference.child("RiderRequests").childByAutoId().setValue(riderRequestDic)
            
            callTaixMode()
            
        }
      }
    }

    @IBAction func logOut(_ sender: UIBarButtonItem) {
        
        do {
            
            try Auth.auth().signOut()
            navigationController?.dismiss(animated: true, completion: nil)
            
        } catch  {
            
            print("User could not sign out")
            
        }
        
        
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
        
        print(locationManger)
        
        
    }
    
    
    func callTaixMode(){
        
        buttonCall.setTitle("取消", for: UIControl.State.normal)
        buttonCall.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        buttonCall.setTitleColor(#colorLiteral(red: 1, green: 0.9862440639, blue: 0.9993811064, alpha: 1), for: UIControl.State.normal)
        HasBeenCalled = true
        
    }
    
    func cancelTaixMode(){
        
        buttonCall.setTitle("呼叫", for: UIControl.State.normal)
        buttonCall.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        buttonCall.setTitleColor(#colorLiteral(red: 1, green: 0.9862440639, blue: 0.9993811064, alpha: 1), for: UIControl.State.normal)
         HasBeenCalled = false
        
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
