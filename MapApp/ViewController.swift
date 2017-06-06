//
//  ViewController.swift
//  MapApp
//
//  Created by ITP312 on 23/5/17.
//  Copyright © 2017 ITP312. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate,
    MKMapViewDelegate {
    
    var locationManager : CLLocationManager?
    
    @IBOutlet weak var mapView : MKMapView!
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)
        //Create Location manager object
        locationManager = CLLocationManager();
        //Set the delegate property of the location manager to self
        locationManager?.delegate = self;
        //Set the most accurate location data as possible
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest;
        // Check for iOS 8. Without this guard the code will // crash with "unknown selector" on iOS 7.
        let ios8 = locationManager?.responds(to:
            #selector(CLLocationManager.requestWhenInUseAuthorization))
        if (ios8!) {
                locationManager?.requestWhenInUseAuthorization(); }
        //Tell the location manager to start looking for its location //immediately
        locationManager?.startUpdatingLocation();
    }
    
    // Implement this function in order to override the look at
    // feel of your callout
    //
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView?
    {
        // Pins can be reused just like table view cells as 
        // they move in and out of the map
        var pinView = mapView.dequeueReusableAnnotationView(
            withIdentifier: "Annotation") as? MKPinAnnotationView
        if pinView == nil
        {
            // Creates a new bluish MKPinAnnotationView using the
            // same reuse ID as above.
            //
            pinView = MKPinAnnotationView(
                annotation: annotation, reuseIdentifier: "Annotation")
            pinView?.pinTintColor = UIColor(
                red: 0.1, green: 0.3, blue: 1, alpha: 0.7)
            pinView?.canShowCallout = true
            pinView?.animatesDrop = true
            // Show an image on the left side of the call out
            //
            let imageView = UIImageView(
                image: UIImage(named: "MapCallout"))
            imageView.frame = CGRect(
                x: 0, y: 0, width: 60, height: 60)
            imageView.contentMode = .scaleAspectFill
            pinView?.leftCalloutAccessoryView = imageView
            // Show a button on the right side of the call out 
            //
            let button = UIButton(type: .infoDark)
            pinView?.rightCalloutAccessoryView = button
    }
    return pinView
}
    
    //== Called frequently each time it update ==
    var lastLocationUpdateTime : Date = Date()
    // This function receives information about the change of the
    // user’s GPS location. The locations array may contain one
    // or more location updates that were collected in-between calls 
    // to this function.
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // There are multiple locations, but we are only 
        // interested in the last one.
        let newLocation = locations.last!;
        // Get find out how old (in seconds) this data was.
        let howRecent = self.lastLocationUpdateTime.timeIntervalSinceNow;
        // Handle only recent events to save power.
        if (abs(howRecent) > 15)
        {
      
            print("Longitude = \(newLocation.coordinate.longitude)");
            print("Latitude = \(newLocation.coordinate.latitude)");
            self.lastLocationUpdateTime = Date()
        }
    }
    
    // This function is triggered if the location manager was unable 
    // to retrieve a location.
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("Could not find location: \(error)");
    }
    //=========================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Do any additional setup ater loading the view,
        //typically from a nib.
        mapView.showsUserLocation = true
        
        
        mapView.mapType = MKMapType.standard
        //configure user interactions
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self;
        
        //Set the region and zoom level
        var span = MKCoordinateSpan()
        span.longitudeDelta = 0.02
        span.latitudeDelta = 0.02
        
        
        //Set the region and zoom level
        // Map startup location
        var location = CLLocationCoordinate2D()
        location.latitude = 1.38012
        location.longitude = 103.85023
        
        //amount of map to dispay
        var region = MKCoordinateRegion()
        region.span = span
        region.center = location
        
        //Set to the region with animated effect
        mapView.setRegion(region, animated: true)
        
        //Add a long press gesture
        //on the MapView
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongGesture))
        self.mapView.addGestureRecognizer(longPressGesture)
        
    }
    
    func handleLongGesture(sender: UIGestureRecognizer)
    {
        //this is important if you only want to
        //receive one tap and hold
        //event
        if (sender.state != UIGestureRecognizerState.began)
        {
            return;
        }
        else
        {
        
            // Here we get the CGPoint for the touch and convert it to
            // latitude and longitude coordinates to display on the map
            let point = sender.location(in: self.mapView)
            let locCoord = self.mapView.convert(point,
                toCoordinateFrom: self.mapView)
            let dropPin = MapAnnotation(coordinate: locCoord,
                                        title: "My Point",
                                        subtitle: "Lat: \(locCoord.latitude), Lng:\(locCoord.longitude)")
            self.mapView.addAnnotation(dropPin)
        


        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

