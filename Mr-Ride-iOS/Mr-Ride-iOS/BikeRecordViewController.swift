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
import CoreData

let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
class BikeRecordViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    var distance = 0.0
    var currentSpeed = 0.0
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var pausedTime = NSTimeInterval()
    var totalTime = NSTimeInterval()
    var date = NSDate()
    var flag = false
    
    lazy var locations = [CLLocation]()
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        // Movement threshold for new events
        _locationManager.distanceFilter = 1.0
        return _locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        counterLabel.font = UIFont(name: "RobotoMono-Light", size:30.0)
        mapView.showsUserLocation = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func startRecord(timer: NSTimer) {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        totalTime = elapsedTime
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
        
        counterLabel.text = String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, fraction)
        
        let calStr = Int(48 * distance * 0.01 * 1.036)
        caloriesLabel.text = String(calStr) + " kcal"
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates(){
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations bikeLocations: [CLLocation]) {
 
        if flag{
            for location in bikeLocations {
                let howRecent = location.timestamp.timeIntervalSinceNow
                
                if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {

                    //update distance
                    if self.locations.count > 0 {
                        distance += location.distanceFromLocation(self.locations.last!)
                        currentSpeed = location.speed
                        
                        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                        mapView.setRegion(region, animated: true)
                        
                        if self.locations.count > 1{
                        let c1 = locations[locations.count-1].coordinate
                        let c2 = locations[locations.count-2].coordinate
                        var coords = [c1, c2]
                        mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
                        }
                    }
                    
                    //save location
                    self.locations.append(location)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(BikeRecordViewController.startRecord(_:)), userInfo: nil, repeats: true)
            date = NSDate()
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
        Record.add(moc, date: date, distance: distance, duration: totalTime, routes: locations)
        var locationArray: [CLLocationCoordinate2D] = []
        for location in locations{
            locationArray.append(CLLocationCoordinate2D(latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude)))
        }
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("AnalysisPage") as! BikeAnalysisViewController
        vc.date = date
        vc.distance = distance
        vc.duration = totalTime
        vc.routes = locationArray
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 10.0
        renderer.strokeColor = UIColor.mrBubblegumColor()
        
        return renderer
    }
    
}
