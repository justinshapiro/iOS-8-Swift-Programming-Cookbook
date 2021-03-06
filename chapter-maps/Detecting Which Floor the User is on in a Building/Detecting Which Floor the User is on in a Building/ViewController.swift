//
//  ViewController.swift
//  Detecting Which Floor the User is on in a Building
//
//  Created by Vandad Nahavandipoor on 7/8/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//
//  These example codes are written for O'Reilly's iOS 8 Swift Programming Cookbook
//  If you use these solutions in your apps, you can give attribution to
//  Vandad Nahavandipoor for his work. Feel free to visit my blog
//  at http://vandadnp.wordpress.com for daily tips and tricks in Swift
//  and Objective-C and various other programming languages.
//  
//  You can purchase "iOS 8 Swift Programming Cookbook" from
//  the following URL:
//  http://shop.oreilly.com/product/0636920034254.do
//
//  If you have any questions, you can contact me directly
//  at vandad.np@gmail.com
//  Similarly, if you find an error in these sample codes, simply
//  report them to O'Reilly at the following URL:
//  http://www.oreilly.com/catalog/errata.csp?isbn=0636920034254

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  var locationManager: CLLocationManager?
  
  func locationManager(manager: CLLocationManager,
    didUpdateLocations locations: [AnyObject]) {
      
      print("Updated locations... \(__FUNCTION__)")
    
      if locations.count > 0{
        let location = (locations as! [CLLocation])[0]
        print("Location found = \(location)")
        if let theFloor = location.floor{
          print("The floor information is = \(theFloor)")
        } else {
          print("No floor information is available")
        }
      }
      
  }
  
  func locationManager(manager: CLLocationManager,
    didFailWithError error: NSError){
      print("Location manager failed with error = \(error)")
  }
  
  func locationManager(manager: CLLocationManager,
    didChangeAuthorizationStatus status: CLAuthorizationStatus){
      
      print("The authorization status of location services is changed to: ", appendNewline: false)
      
      switch CLLocationManager.authorizationStatus(){
      case .Denied:
        print("Denied")
      case .NotDetermined:
        print("Not determined")
        if let manager = locationManager{
          manager.requestWhenInUseAuthorization()
        }
      case .Restricted:
        print("Restricted")
      default:
        print("Authorized")
      }
      
  }
  
  func displayAlertWithTitle(title: String, message: String){
    let controller = UIAlertController(title: title,
      message: message,
      preferredStyle: .Alert)
    
    controller.addAction(UIAlertAction(title: "OK",
      style: .Default,
      handler: nil))
    
    presentViewController(controller, animated: true, completion: nil)
    
  }
  
  func createLocationManager(startImmediately startImmediately: Bool){
    locationManager = CLLocationManager()
    if let manager = locationManager{
      print("Successfully created the location manager")
      manager.delegate = self
      if startImmediately{
        manager.startUpdatingLocation()
      }
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    /* Are location services available on this device? */
    if CLLocationManager.locationServicesEnabled(){
      
      /* Do we have authorization to access location services? */
      switch CLLocationManager.authorizationStatus(){
      case .Denied:
        /* No */
        displayAlertWithTitle("Denied",
          message: "Location services are not allowed for this app")
      case .NotDetermined:
        /* We don't know yet, we have to ask */
        createLocationManager(startImmediately: false)
        if let manager = self.locationManager{
          manager.requestWhenInUseAuthorization()
        }
      case .Restricted:
        /* Restrictions have been applied, we have no access
        to location services */
        displayAlertWithTitle("Restricted",
          message: "Location services are not allowed for this app")
      default:
        createLocationManager(startImmediately: true)
      }
      
      
    } else {
      /* Location services are not enabled.
      Take appropriate action: for instance, prompt the
      user to enable the location services */
      print("Location services are not enabled")
    }
  }
  
}

