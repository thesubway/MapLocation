//
//  ViewController.swift
//  MapLocation
//
//  Created by Dan Hoang on 8/18/14.
//  Copyright (c) 2014 Dan Hoang. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,UITextFieldDelegate,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            println("authorized!")
            //this status is for always requesting
            self.mapView.showsUserLocation = true
//            self.locationManager.startUpdatingLocation()
            
        case .NotDetermined:
            println("initial launch")
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("Don't glare at me. Someone else is blocking you.")
        case .AuthorizedWhenInUse:
            println("authorized, and you're using it too.")
            self.mapView.showsUserLocation = true
            //saves power:
            self.locationManager.startMonitoringSignificantLocationChanges()
            
            //this is the significant location monitoring, will only fire when location changes > 500 meters
            
            
        case .Denied:
            println("plead the user to turn it on.")
        }
        
        self.latitude.delegate = self
        self.longitude.delegate = self
        
//        var ground = CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0444)
//        var eye = CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0442)
//        
//        var camera = MKMapCamera(lookingAtCenterCoordinate: ground, fromEyeCoordinate: eye, eyeAltitude: 50)
//        self.mapView.camera = camera
        
        var pan = UIPanGestureRecognizer(target: self, action: "mapPanned:")
        self.view.addGestureRecognizer(pan)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("MEMORY LOW")
    }
    
    func mapPanned(sender : UIPanGestureRecognizer) {
        
        switch sender.state {
        case .Changed:
            var point = sender.translationInView(self.view)
            //this is where the user's panning brings it to.
            println(point)
        default:
            println("default")
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
//            println("they said yes")
            self.mapView.showsUserLocation = true
//            self.locationManager.startUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
            
        case .Denied:
            println("denied from map app using maps.")
        case .AuthorizedWhenInUse:
            println("said yes, and it's in use too")
            //show user location:
            self.mapView.showsUserLocation = true
        default:
            println("default notification about authorization changed.")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        print("location new update, coordinates are: ")
        if let location = locations.last as? CLLocation {
            println(location.coordinate.latitude)
            println(location.coordinate.longitude)
        }
        else {
            println()
        }
    }
    
    //ensure textfield leaves.
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func movePressed(sender: AnyObject) {
        var latString = NSString(string: self.latitude.text)
        var lat = latString.doubleValue
        
        var longString = NSString(string: self.longitude.text)
        var long = longString.doubleValue
        
        var newLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        var region = MKCoordinateRegionMakeWithDistance(newLocation, 1000, 1000)
        
        self.mapView.setRegion(region, animated: true)
    }
}

