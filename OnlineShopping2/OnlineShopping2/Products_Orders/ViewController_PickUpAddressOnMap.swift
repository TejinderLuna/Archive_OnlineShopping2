//
//  ViewPickUpAddressViewController.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/17/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController_ViewPickUpAddress: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pickUpSpotMap: MKMapView!
    
    
    let locManager = CLLocationManager()
//    let currentLoc:CLLocation = CLLocation(latitude: 43.7304639, longitude: -79.60151)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        //        displayMap()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLoc = locations[0]
        
        // defining the coordinates
        let myLocationCoordinates:CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude)
        
        // Defining the span for zooming into location
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.018, 0.018)
        
        // Defining the region
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocationCoordinates, span)
        
        // setting the region for the mapview
        pickUpSpotMap.setRegion(region, animated: true)
        
//        print("currentLoc.coordinate.latitude: ", currentLoc.coordinate.latitude)
//        print("currentLoc.coordinate.longitude: ", currentLoc.coordinate.longitude)
        
        pickUpSpotMap.showsUserLocation = true
        
        //        displayMap(myLocationCoordinates: myLocationCoordinates)
        
        plotRoute(currentLoc: currentLoc)
    }

    
    private func displayMap(myLocationCoordinates:CLLocationCoordinate2D) {
        addressLabel.text = pickupAddressArray[orderIndex]
        
        let pickUpAddress = pickupAddressArray[orderIndex]
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(pickUpAddress) {
            (placemarks, error) in
            guard
                let placemarks = placemarks,
                let placemark = placemarks.first?.location
                else {
                    // if failed to get placemark
                    print(error.debugDescription)
                    return
            }
            let lat = placemark.coordinate.latitude
            let long = placemark.coordinate.longitude
            let location = CLLocationCoordinate2DMake(lat, long)
            let span = MKCoordinateSpanMake(0.018, 0.018)
            let region = MKCoordinateRegionMake(location, span)
            
//            print("pickUpSpot coordinate.latitude: ", lat)
//            print("pickUpSpot coordinate.longitude: ", long)
//            print("currentLoc.coordinate.latitude: ", myLocationCoordinates.latitude)
//            print("currentLoc.coordinate.longitude: ", myLocationCoordinates.longitude)
            
            self.pickUpSpotMap.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            annotation.title = "My Pick Up Spot"
            annotation.subtitle = pickUpAddress
            
            self.pickUpSpotMap.addAnnotation(annotation)
        }
        
    }
    
    private func plotRoute(currentLoc:CLLocation) {
        
        addressLabel.text = pickupAddressArray[orderIndex]
        
        // Get location text
        let locEnteredText = pickupAddressArray[orderIndex]
        
        
        // Convert text input to lat-lng
        // using CLGeocoder object
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locEnteredText, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error!)
            }
            if let placemark = placemarks?.first {
                
                // Convert location into lat-lng
                // and then center map there and drop a pin.
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = "My Pick Up Spot"
                dropPin.subtitle = locEnteredText
                self.pickUpSpotMap.addAnnotation(dropPin)
                self.pickUpSpotMap.selectAnnotation( dropPin, animated: true)
                
                // Calculate directions
                let request = MKDirectionsRequest()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate:currentLoc.coordinate,  addressDictionary: nil))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                request.requestsAlternateRoutes = false
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                directions.calculate (completionHandler: { [unowned self] response, error in
                    
                    for route in (response?.routes)! {
                        print("Route hithit")
                        self.pickUpSpotMap.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                        self.pickUpSpotMap.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding:UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0), animated: true)
                        
                    }

                })
                
            }
        })
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 3.0;
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
