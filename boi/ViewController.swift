//
//  ViewController.swift
//  boi
//
//  Created by Bryan Kyritz on 10/17/18.
//  Copyright © 2018 Bryan Kyritz. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import UserNotifications
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let manager = CLLocationManager()
    var myCord = CLLocationCoordinate2D()       //the coordinate you are at
    var savedCord = CLLocationCoordinate2D()    //saved coorinate
    let locationCircleRadius = 50.0     //The radius of your destination
    var isInRange = false //is user is in bounds
    
    //search for destination
    @IBAction func searchDestination(_ sender: UIButton)
    {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)    }
    
    
    //switches
    @IBAction func goToCalc(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "secondViewSegue", sender: self)
    }
    
    //called when user searches an address / place
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //hide searchbar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        //create search request
        
        let searchRequest = MKLocalSearch.Request()
        
        searchRequest.naturalLanguageQuery = searchBar.text
        searchRequest.region = mapView.region
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if(response == nil)
            {
                print("error")
            }
            else
            {
                let locationLatitude = response?.boundingRegion.center.latitude
                let locationLongitude = response?.boundingRegion.center.longitude
                
                let destinationCord = CLLocationCoordinate2DMake(locationLatitude!,locationLongitude!)
                self.savedCord = destinationCord
                let annotation = MKPointAnnotation()
                annotation.coordinate = destinationCord
                annotation.title = searchBar.text
                annotation.subtitle = "Your Destination"
                self.mapView.addAnnotation(annotation)
                let circle = MKCircle(center: destinationCord ,radius: self.locationCircleRadius)
                self.mapView.addOverlay(circle, level: .aboveRoads)
            }
        }
    
    }
    
    //Notifies user that they are in range of destination
    func notifyInRange()
    {
        let alarm = UNMutableNotificationContent()
        alarm.title = "Geo-Notify"
        alarm.body = "You have reached your destination"
        alarm.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Message", content: alarm, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        AudioServicesPlaySystemSound(SystemSoundID(1304))
    }
    
    
    //save button
    @IBAction func save(_ sender: UIButton)
    {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = myCord
        annotation.title = "Your saved location"
        annotation.subtitle = "Your location"
        mapView.addAnnotation(annotation)
        savedCord = myCord
        let circle = MKCircle(center: savedCord,radius: locationCircleRadius)
        mapView.addOverlay(circle, level: .aboveRoads)
        checkInRange()
        
    }
    
    
    //Renders ranges from destinations
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle
        {
            let circleRender = MKCircleRenderer(overlay: overlay)
            if(!isInRange)
            {
                circleRender.fillColor = UIColor.blue
                circleRender.strokeColor = UIColor.blue
            }
            else
            {
                circleRender.fillColor = UIColor.green
                circleRender.strokeColor = UIColor.green
            }
            circleRender.lineWidth = 1
            circleRender.alpha = 0.3
            return circleRender
        }
        return MKCircleRenderer(overlay: overlay)
    }
    //updates Player position on map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        myCord = location.coordinate //updates your coordinate
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center : myLocation,span: span)
        
        mapView.setRegion(region, animated:false)
        self.mapView.showsUserLocation = true
        
        checkInRange()
    }
    
    var coverGreenCirc = MKCircle(center:  CLLocationCoordinate2D(latitude: 0, longitude: 0),radius:  0)
    var addedGreen = false
    
    func checkInRange()
    {
        let myLoc = CLLocation(latitude: myCord.latitude, longitude: myCord.longitude)
        let destLoc = CLLocation(latitude: savedCord.latitude, longitude: savedCord.longitude)
        let distance = myLoc.distance(from: destLoc)
        if(distance < locationCircleRadius)
        {
            notifyInRange()
            isInRange = true
            if(!addedGreen)
            {
                coverGreenCirc = MKCircle(center: savedCord,radius: locationCircleRadius)
                mapView.addOverlay(coverGreenCirc, level: .aboveRoads)
                addedGreen = true
            }
        }
        else
        {
            mapView.removeOverlay(coverGreenCirc)
            addedGreen = false
            isInRange = false
        }
    }
    //runs when the program starts
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler:  {didAllow, error in})
    }
    
}


