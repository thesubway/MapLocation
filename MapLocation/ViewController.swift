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
            self.mapView.showsUserLocation = true
            
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
        
        //this part enables dropping of pin:
        var longPress = UILongPressGestureRecognizer(target: self, action: "mapPressed:")
        self.mapView.addGestureRecognizer(longPress)
        
        self.mapView.delegate = self
        
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
    
    func mapPressed(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .Began:
            println("Began")
            //figuring out where they touched on the mapview
            var touchPoint = sender.locationInView(self.mapView)
            var touchCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            //setting up our pin
            var annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Create your Reminder"
            //now add coordinate to other view's tableView:
            self.mapView.addAnnotation(annotation)
            
        case .Changed:
            println("Changed")
        case .Ended:
            println("Ended")
        default:
            println("default")
        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        //very similar to tableview cell for row at index path
        
        //dequeue old one, just like cells
        if let annotV = mapView.dequeueReusableAnnotationViewWithIdentifier("Pin") as? MKPinAnnotationView {
            
            //if we didnt get one back, create a new one with identifier
            self.setupAnnotationView(annotV)
            return annotV
        }
            
        else {
            
            var annotV = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            self.setupAnnotationView(annotV)
            return annotV
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        //tells us which annotation was clicked
        var annotation = view.annotation
        
        var geoRegion = CLCircularRegion(center: annotation.coordinate, radius: 200, identifier: "Reminder")
        self.locationManager.startMonitoringForRegion(geoRegion)
        
        println("Go to the add page.")
        println(annotation.coordinate.latitude)
        println(annotation.coordinate.longitude)
        
//        let remindersVC = self.storyboard.instantiateViewControllerWithIdentifier("remindersVC") as RemindersViewController
//        self.navigationController.pushViewController(remindersVC, animated: true)
        let addReminderVC = self.storyboard.instantiateViewControllerWithIdentifier("addReminder") as AddReminderViewController
        self.navigationController.pushViewController(addReminderVC, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
//            println("they said yes")
            self.mapView.showsUserLocation = true
//            self.locationManager.startUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
            
        case .Denied:
            println("denied from map app, using maps.")
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
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("did enter region")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("did exit region")
    }
    
    
    func setupAnnotationView(annotationView : MKPinAnnotationView) {
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        var rightButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = rightButton
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

