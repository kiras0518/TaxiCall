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
    var driverLocation = CLLocationCoordinate2D()
    var driverOrder = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonCall: UIButton!
    
    @IBAction func callTaxi(_ sender: UIButton) {
        
        if !driverOrder {
            
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
        
        //print(locationManger)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.updateLocation()
        }
        
    }
    
    
    func updateLocation() {
     
        if let email = Auth.auth().currentUser?.email {
            
            reference.child("RiderRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(DataEventType.childAdded) { (dataSnapShot) in
                
                self.callTaixMode()
                
                if let driverRequestDic = dataSnapShot.value as? [String : Any] {
                    
                    if let driverLat = driverRequestDic["driverLat"] as? Double {
                        
                        if let driverLon = driverRequestDic["driverLon"] as? Double {
                            
                            self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                            self.driverOrder = true
                            self.reference.child("RiderRequests").removeAllObservers()
                            
                        }
                    }
                    
                }
                
            }
        }
        
    }
    

    func displayDriverAndRider() {
        
        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        let riderCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
        let roundedDistance = round(distance * 100) / 100
        buttonCall.setTitle("司機距離剩餘位置 \(roundedDistance) km ", for: UIControl.State.normal)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let riderAnnotation = MKPointAnnotation()
        riderAnnotation.coordinate = userLocation
        riderAnnotation.title = "你的位置"
        mapView.addAnnotation(riderAnnotation)
        
        let driverAnnotation = MKPointAnnotation()
        driverAnnotation.coordinate = driverLocation
        driverAnnotation.title = "司機位置"
        mapView.addAnnotation(driverAnnotation)
        
        let latDelta = abs(driverLocation.latitude - userLocation.latitude) * 2.5
        let lonDelta = abs(driverLocation.longitude  - userLocation.longitude) * 2.5
        
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        mapView.setRegion(region, animated: true)
        
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
            
            userLocation = cooridnate
            
            if driverOrder {
                
                displayDriverAndRider()
                
            } else {
                
                let region = MKCoordinateRegion(center: cooridnate, span: MKCoordinateSpan(latitudeDelta: 0.018, longitudeDelta: 0.018))
                
                mapView.setRegion(region, animated: true)
                
                mapView.removeAnnotations(mapView.annotations)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = cooridnate
                annotation.title = "我的位置"
                mapView.addAnnotation(annotation)
                
            }
            
            
            
            
            
        }
    }
   

}
