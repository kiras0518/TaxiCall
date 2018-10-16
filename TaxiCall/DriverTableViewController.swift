//
//  DriverTableViewController.swift
//  TaxiCall
//
//  Created by YU on 2018/10/15.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class DriverTableViewController: UITableViewController, CLLocationManagerDelegate {

    let reference = Database.database().reference()
    //var riderRequestDic : [String : Any] = [:]
    var riderRequests : [DataSnapshot] = []
    let locationManager = CLLocationManager()
    var driverLocation = CLLocationCoordinate2D()
    
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        
        do {
            
            try Auth.auth().signOut()
            navigationController?.dismiss(animated: true, completion: nil)
            
        } catch  {
            
            print("Driver could not sign out")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRiderData()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.tableView.reloadData()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        driverLocation = (manager.location?.coordinate)!
        print(driverLocation)
        
    }
    
    // MARK: - Table view data source
    
    func getRiderData(){
        
        reference.child("RiderRequests").observe(DataEventType.childAdded) { (DataSnapshot) in
            //print(DataSnapshot.value)
          
                self.riderRequests.append(DataSnapshot)
                DataSnapshot.ref.removeAllObservers()
                self.tableView.reloadData()
           
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let snapShot = riderRequests[indexPath.row]
        performSegue(withIdentifier: "pickupSegue", sender: snapShot)
      
    }
    
    //在跳轉之前 傳遞數據
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickupSegue" {
            
            let destiantionVC =  segue.destination as! PickUpViewController
            
            if let snapShot = sender as? DataSnapshot {
                
                if let riderRequestDic = snapShot.value as? [String: Any] {
                    
                    if let email = riderRequestDic["email"] as? String {
                        if let latitude = riderRequestDic["latitude"] as? Double {
                            if let longitude = riderRequestDic["longitude"] as? Double {
                                
                                destiantionVC.riderEmail = email
                                
                                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                
                                destiantionVC.riderLocation = location
                                destiantionVC.driverLocation = driverLocation
                                
                            }
                        }
                    }
                    
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return riderRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RiderDataCell

        let snapShot = riderRequests[indexPath.row]
        
        if let riderRequestDic = snapShot.value as? [String : Any] {
            
            if let email = riderRequestDic["email"] as? String {
                
                if let latitude = riderRequestDic["latitude"] as? Double {
                    
                    if let longitude = riderRequestDic["longitude"] as? Double {
                        
                        let riderCLLocation = CLLocation(latitude: latitude, longitude: longitude)
                        
                        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                        
                        let distance =  riderCLLocation.distance(from: driverCLLocation) / 1000
                        let roundeDistance = round(distance * 100 ) / 100
                        
                        if let image = UIImage(named: "user") {
                            
                            let riderDetails = "\(roundeDistance) km"
                            
                            cell.configureCell(profileImage: image, email: email, data: riderDetails)
                            
                        }
                        
                        
                    }
                    
                }
            }
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
