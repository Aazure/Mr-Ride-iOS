//
//  BikeRecordViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/31.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
//import HealthKit


class BikeRecordViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    //    var count = 0
    //    var seconds = 0.0
    var distance = 0.0
    var currentSpeed = 0.0
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var pausedTime = NSTimeInterval()
    var flag = false
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 1.0
        return _locationManager
    }()
    lazy var locations = [CLLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        counterLabel.font = UIFont(name: "RobotoMono-Light", size:30.0)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let userLocation = locations.last
        let region = MKCoordinateRegion(center: userLocation!.coordinate, span: MKCoordinateSpanMake(0.005,0.005))
        mapView.setRegion(region, animated: true)
        
        if flag{
            for location in locations{
                if location.horizontalAccuracy < 20{
                    if self.locations.count > 0{
                        distance += location.distanceFromLocation(self.locations.last!)
                        currentSpeed = location.speed
                    }
                    print(location)
                    self.locations.append(location)
                }
            }
        }
    }
    
    func startRecord(timer: NSTimer) {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        let distanceStr = NSString(format: "%.2f", distance)
        distanceLabel.text = (distanceStr as String) + " m"
        let pace = currentSpeed * 3.6
        let paceStr = NSString(format: "%.2f", pace)
        paceLabel.text = (paceStr as String) + " km / h"
        
        let hours = UInt8(elapsedTime / 3600.0)
        elapsedTime -= (NSTimeInterval(hours) * 3600)
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        let fraction = UInt8(elapsedTime * 100)
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        counterLabel.text = "\(strHours):\(strMinutes):\(strSeconds).\(strFraction)"
    }
    
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates(){
        locationManager.stopUpdatingLocation()
    }
    
    //    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    //        for location in locations as! [CLLocation] {
    //            let howRecent = location.timestamp.timeIntervalSinceNow
    //
    //            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
    //                //update distance
    //                if self.locations.count > 0 {
    //                    distance += location.distanceFromLocation(self.locations.last)
    //
    //                    var coords = [CLLocationCoordinate2D]()
    //                    coords.append(self.locations.last!.coordinate)
    //                    coords.append(location.coordinate)
    //
    //                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
    //                    mapView.setRegion(region, animated: true)
    //
    //                    mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
    //                }
    //
    //                //save location
    //                self.locations.append(location)
    //            }
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissRecord(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    enum Counter{
        case Begin
        case Pause
        case Continue
    }
    
    var buttonStatus = Counter.Begin
    
    @IBAction func startPressed(sender: UIButton) {
        switch buttonStatus{
        case .Begin:
            locations.removeAll(keepCapacity: false)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(BikeRecordViewController.startRecord(_:)), userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            flag = true
            startLocationUpdates()
            buttonStatus = .Pause
        case .Pause:
            timer.invalidate()
            pausedTime = NSDate.timeIntervalSinceReferenceDate()
            flag = false
            stopLocationUpdates()
            buttonStatus = .Continue
        case .Continue:
            startTime = NSDate.timeIntervalSinceReferenceDate() - pausedTime + startTime
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(BikeRecordViewController.startRecord(_:)), userInfo: nil, repeats: true)
            flag = true
            startLocationUpdates()
            buttonStatus = .Pause
        }
    }
    
    @IBAction func finishPressed(sender: AnyObject) {
        //save data
        print("finish")
        let vc = BikeAnalysisViewController()
        
    }
    
    
}

//extension BikeRecordViewController: MKMapViewDelegate {
//    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//        if !overlay.isKindOfClass(MKPolyline) {
//            return
//        }
//
//        let polyline = overlay as! MKPolyline
//        let renderer = MKPolylineRenderer(polyline: polyline)
//        renderer.strokeColor = UIColor.blueColor()
//        renderer.lineWidth = 3
//        return renderer
//    }
//    
//    
//}


