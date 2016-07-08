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

//protocol ShowHomePageInfoDelegate: class{
//    func showHomePage()
//}
let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
class BikeRecordViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var finishButton: UIBarButtonItem!
    var test = "fail"
    
    var distance = 0.0
    var currentSpeed = 0.0
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var pausedTime = NSTimeInterval()
    var totalTime = NSTimeInterval()
    var date = NSDate()
    var flag = false
    //    weak var delegation:ShowHomePageInfoDelegate?
    
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
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        setupNavigation()
        setupRecordButton()
        setupBackground()
        setupMapView()
        setupCircleView()
        counterLabel.font = UIFont(name: "RobotoMono-Light", size:30.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        locationManager.requestAlwaysAuthorization()
        //        locationManager.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
        timer.invalidate()
    }
    
    func setupNavigation(){
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func setupMapView(){
        mapView.delegate = self
        mapView.layer.cornerRadius = 4
        mapView.showsUserLocation = true
    }
    
    func setupCircleView(){
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.layer.borderWidth = 4
        circleView.layer.borderColor = UIColor.whiteColor().CGColor
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
        
        let weight = NSUserDefaults.standardUserDefaults().doubleForKey("weight")
        
        let calStr = Int(weight * distance * 0.001 * 1.036)
        caloriesLabel.text = String(calStr) + " kcal"
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates(){
        locationManager.stopUpdatingLocation()
    }
    
    func setupRecordButton(){
        recordButton.backgroundColor = UIColor.redColor()
        recordButton.layer.cornerRadius = recordButton.frame.width / 2
        recordButton.clipsToBounds = true
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
        //        delegation?.showHomePage()
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
            buttonSquareAnimation()
            buttonStatus = .Pause
            
        case .Pause:
            timer.invalidate()
            pausedTime = NSDate.timeIntervalSinceReferenceDate()
            flag = false
            stopLocationUpdates()
            buttonCircleAnimation()
            buttonStatus = .Continue
            
        case .Continue:
            startTime = NSDate.timeIntervalSinceReferenceDate() - pausedTime + startTime
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(BikeRecordViewController.startRecord(_:)), userInfo: nil, repeats: true)
            flag = true
            startLocationUpdates()
            buttonSquareAnimation()
            buttonStatus = .Pause
        }
    }
    
    @IBAction func finishPressed(sender: AnyObject) {
        Record.add(moc, date: date, distance: distance, duration: totalTime, routes: locations)
        var locationArray: [CLLocationCoordinate2D] = []
        for location in locations{
            locationArray.append(CLLocationCoordinate2D(latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude)))
        }
        let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("AnalysisPage") as! BikeAnalysisViewController
        destinationVC.date = date
        destinationVC.distance = distance
        destinationVC.duration = totalTime
        destinationVC.routes = locationArray
        self.navigationController!.pushViewController(destinationVC, animated: true)
    }
    
    func buttonSquareAnimation(){
        UIView.animateWithDuration(0.6, delay: 0.0,options: .TransitionFlipFromLeft, animations:{
            self.recordButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
            },completion: { (isFinished)in
                self.addIconCornerRadiusAnimation((self.recordButton.bounds.width) / 2, to: 8, duration: 0.3)
        })
        
    }
    
    func buttonCircleAnimation(){
        UIView.animateWithDuration(0.6){
            self.recordButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
            self.recordButton.layer.cornerRadius = self.recordButton.bounds.width / 2
        }
        
    }
    
    func addIconCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
    {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        self.recordButton.layer.addAnimation(animation, forKey: "cornerRadius")
        self.recordButton.layer.cornerRadius = to
    }
    
    
    func setupBackground() {
        self.view.backgroundColor = UIColor.mrLightblueColor()
        let topGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60).CGColor
        let bottomGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).CGColor
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [topGradient, bottomGradient]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 5.0
        renderer.strokeColor = UIColor.mrBubblegumColor()
        
        return renderer
    }
    
    
}
