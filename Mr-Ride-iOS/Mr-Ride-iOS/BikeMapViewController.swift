//
//  BikeMapViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/6/15.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import MapKit

class BikeMapViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    enum MakerType: String{
        case Toilets
        case YouBikes
    }
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var catelogLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var pickView: UIPickerView!
    
    @IBOutlet weak var pickViewToolBar: UIView!
    @IBOutlet weak var mapTypeButton: UIButton!
    
    var currentUserLocation: CLLocation? = nil
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
    
    let pickerData = ["UBike Station", "Toilet"]
    
    override func viewWillAppear(animated: Bool) {
    TrackingManager.sharedManager.createTrackingScreenView("view_in_toilet_map")
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Map"
        setNavigation()
        setupMapView()
        setupInfoView()
        setupPickView()
        setupSidebar()
        BikeMapManager.sharedManager.getYouBikes(){ data in
            self.addYouBikeAnnotations(data)
            self.locationManager.startUpdatingLocation()
            //                self.setupUserLocation()
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    
    func setNavigation(){
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //                self.navigationBar.barStyle = .Black
        
    }
    
    func setupSidebar(){
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func setupMapView(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 10.0
    }
    
    func setupInfoView(){
        
        infoView.layer.cornerRadius = 10.0
        infoView.hidden = true
        infoView.hidden = true
    }
    
    func setupPickView(){
        pickView.hidden = true
        pickView.backgroundColor = UIColor.whiteColor()
        self.pickView.dataSource = self
        self.pickView.delegate = self
        pickViewToolBar.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentUserLocation = locations.last
        
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        var imageName = "icon-station"
        if let mapAnnotation = annotation as? MapAnnotation{
            switch mapAnnotation.type!{
            case "toilet":
                imageName = "icon-toilet"
            case "youbike":
                imageName = "icon-station"
            default:
                break
            }
            
        }
        
        let anView = MKAnnotationView()
        
        let iconImage = UIImage(named: imageName)
        let tintedImage = iconImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let iconImageView = UIImageView(image: tintedImage)
        iconImageView.tintColor = .mrDarkSlateBlueColor()
        
        anView.backgroundColor = .whiteColor()
        anView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        anView.layer.cornerRadius = anView.frame.width / 2
        anView.canShowCallout = true
        
        anView.addSubview(iconImageView)
        iconImageView.center = anView.center
        return anView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        infoView.hidden = false
        view.backgroundColor =  UIColor.mrLightblueColor()
        if let selectedAnnotation = view.annotation as? MapAnnotation{
                        switch selectedAnnotation.type!{
                        case "toilet":
                            TrackingManager.sharedManager.createTrackingScreenView("view_in_toilet_map")
                        case "youbike":
                            TrackingManager.sharedManager.createTrackingScreenView("view_in_ubike_station_map")
                        default:
                            break
                        }
            titleLabel.text = selectedAnnotation.title
            addressLabel.text = selectedAnnotation.address
            catelogLabel.text = selectedAnnotation.catelog
            catelogLabel.layer.cornerRadius = 2
            catelogLabel.layer.borderWidth = 0.5
            catelogLabel.layer.borderColor = UIColor.whiteColor().CGColor
            let request = MKDirectionsRequest()
            let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
            request.source = sourceItem
            let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: (selectedAnnotation.coordinate), addressDictionary: nil))
            request.destination = destinationItem
            let direction = MKDirections(request: request)
            direction.calculateETAWithCompletionHandler{(response, error) -> Void in
                if let error = error{
                    print("Error while requesting ETA:\(error.localizedDescription)")
                }else{
                    self.etaLabel.text = "\(Int((response?.expectedTravelTime)! / 60)) mins"
                }
            }
            
        }
        
        
        
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        infoView.hidden = true
        view.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func mapTypeChanged(sender: UIButton) {
        TrackingManager.sharedManager.createTrackingScreenView("view_in_look_for_picker")
        pickView.hidden = false
        pickViewToolBar.hidden = false
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row{
        case 0:
            mapTypeButton.titleLabel?.text = pickerData[row]
            BikeMapManager.sharedManager.getYouBikes(){ data in
                self.addYouBikeAnnotations(data)
                //                self.setupUserLocation()
                
            }
        case 1:
            mapTypeButton.titleLabel?.text = pickerData[row]
            BikeMapManager.sharedManager.getToilets(){data in
                
                self.addToiletAnnotations(data)
                //                self.setupUserLocation()
            }
        default:
            break
        }
        infoView.hidden = true
    }
    
    func addYouBikeAnnotations(youbikes: [BikeYouBikeModel]){
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MapAnnotation]()
        
        for youbike in youbikes{
            let availableYB = String(format: "%d bikes left", youbike.availableYB)
            let annotation = MapAnnotation(type: "youbike", catelog: youbike.area, address: youbike.address)
            annotation.title = youbike.name
            annotation.subtitle = availableYB
            annotation.coordinate = youbike.coordinate
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        
    }
    
    func addToiletAnnotations(toilets: [BikeToiletModel]){
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MapAnnotation]()
        
        for toilet in toilets{
            let annotation = MapAnnotation(type: "toilet", catelog: toilet.catelog, address: toilet.address)
            annotation.title = toilet.name
            annotation.coordinate = toilet.coordinate
            annotations.append(annotation)
            
        }
        mapView.addAnnotations(annotations)
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        pickView.hidden = true
        pickViewToolBar.hidden = true
        TrackingManager.sharedManager.createTrackingEvent("look_for_picker", action: "select_done_in_look_for_picker")
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        pickView.hidden = true
        pickViewToolBar.hidden = true
        TrackingManager.sharedManager.createTrackingEvent("look_for_picker", action: "select_cancel_in_look_for_picker")
    }
    
}
