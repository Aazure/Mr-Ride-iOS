//
//  BikeAnalysisViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/31.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

class BikeAnalysisViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var date: NSDate?
    var distance: Double?
    var duration: Double?
    var routes: [Route] = []
    var isFromTable = false
//    lazy var locationManager: CLLocationManager = {
//        var _locationManager = CLLocationManager()
//        _locationManager.delegate = self
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        _locationManager.activityType = .Fitness
//        
//        _locationManager.distanceFilter = 1.0
//        return _locationManager
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Route.getAllLocation(moc)
        setNavigation()
        setLabel()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        mapView.showsUserLocation = true
        for route in routes{
            print(route.latitude)
            print(route.longitude)
            print(route.created)
        }
        createPolyLine()
    }
    
    func setNavigation(){
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    
    }
    
    func setLabel(){
        let distanceStr = NSString(format: "%.2f", distance!)
        distanceLabel.text = String(distanceStr) + " m"
        let speedStr = NSString(format: "%.2f", distance! / duration! * 3.6)
        avgSpeedLabel.text = String(speedStr) + " km / h"
        
        let hours = UInt8(duration! / 3600.0)
        duration! -= (NSTimeInterval(hours) * 3600)
        let minutes = UInt8(duration! / 60.0)
        duration! -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(duration!)
        duration! -= NSTimeInterval(seconds)
        let fraction = UInt8(duration! * 100)
        
        durationLabel.text = String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, fraction)

        let calStr = Int(48 * distance! * 0.01 * 1.036)
        caloriesLabel.text = String(calStr) + " kcal"
    
    }
    
    func createPolyLine(){
        var locations = [
            CLLocation(latitude: 32.7767, longitude: -96.7970),         /* San Francisco, CA */
            CLLocation(latitude: 37.7833, longitude: -122.4167),        /* Dallas, TX */
            CLLocation(latitude: 42.2814, longitude: -83.7483),         /* Ann Arbor, MI */
            CLLocation(latitude: 32.7767, longitude: -96.7970)          /* San Francisco, CA */
        ]
        
        addPolyLineToMap(locations)
        print(1)
        
    }
    
    func addPolyLineToMap(locations: [CLLocation!]){
        var coordinates = locations.map({ (location: CLLocation!)
        -> CLLocationCoordinate2D in
            return location.coordinate
        })
        
        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        self.mapView.addOverlay(polyline)
        self.mapView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
        print(coordinates)
    
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer{
        if overlay is MKPolyline{
            let pr = MKPolylineRenderer(overlay:overlay)
            pr.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            pr.lineWidth = 3
            return pr
        }
        return MKOverlayRenderer()
//        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
//        renderer.strokeColor = UIColor.blueColor()
//        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeAnalysis(sender: AnyObject) {
        if isFromTable{
        self.navigationController!.popToRootViewControllerAnimated(true)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
