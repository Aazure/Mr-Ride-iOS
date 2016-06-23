//
//  BikeMapViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/6/15.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import MapKit

class BikeMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    enum MakerType: String{
        case Toilets
        case YouBikes
    }
    @IBOutlet weak var catelogLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
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
    
    var toilets: [BikeToiletModel] = []
    var toiletAnnotations: [MKAnnotation] = []
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0) ){
            BikeMapManager.sharedManager.getToilets()
            //            self.locationManager.startUpdatingLocation()
            let toilets = BikeMapManager.sharedManager.toilets
            for toilet in toilets{
                let toiletAnnotation = MKPointAnnotation()
                toiletAnnotation.coordinate = toilet.coordinate
                toiletAnnotation.title = toilet.name
                toiletAnnotation.subtitle = toilet.address
                self.toiletAnnotations.append(toiletAnnotation)
            }
            dispatch_async(dispatch_get_main_queue()){
                //                self.locationManager.startUpdatingLocation()
                self.mapView.addAnnotations(self.toiletAnnotations)
                
            }
        }
        //        locationManager.startUpdatingLocation()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Map"
        setNavigation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 10.0
        
        
        
        
        
        //        self.locationManager.startUpdatingLocation()
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.mapView.reloadInputViews()
        
        // Do any additional setup after loading the view.
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
        //        self.navigationBar.barStyle = .Black
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        print(4)
        currentUserLocation = locations.last
        //        let region = MKCoordinateRegionMakeWithDistance(currentUserLocation!.coordinate, 500, 500)
        //        mapView.setRegion(region, animated: true)
        //        print(5)
        
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationReusedId = "Toilet"
        
        if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReusedId)
        if anView == nil{
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReusedId)
            anView?.canShowCallout = true
        }else{
            anView?.annotation = annotation
        }
        let iconImage = UIImage(named: "icon-toilet")
        let tintedImage = iconImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let iconImageView = UIImageView(image: tintedImage)
        iconImageView.tintColor = .mrDarkSlateBlueColor()
        
        anView?.backgroundColor = .whiteColor()
        anView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        anView?.layer.cornerRadius = (anView?.frame.width)! / 2
        //        anView?.clipsToBounds = true
        
        anView?.addSubview(iconImageView)
        iconImageView.center = (anView?.center)!
        return anView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        print(selectedAnnotation?.title)
        addressLabel.text = (selectedAnnotation?.subtitle!)! as String
        titleLabel.text = (selectedAnnotation?.title!)! as String
        view.backgroundColor =  UIColor.mrLightblueColor()
        
        let request = MKDirectionsRequest()
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
        request.source = sourceItem
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: (selectedAnnotation?.coordinate)!, addressDictionary: nil))
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
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        view.backgroundColor = UIColor.whiteColor()
    }
    
    
    //    func getToiletsData() {
    //
    //        let mapDataManager = BikeMapManager()
    //
    //        mapDataManager.getToilets(
    //            success: { [weak self] toilets in
    //
    //                guard let weakSelf = self else { return }
    //
    //                weakSelf.toilets = toilets
    //
    //                //weakSelf.setupToiletMarkers()
    //            },
    //            failure: { error in
    //
    //                print("ERROR: \(error)")
    //            }
    //        )
    
    
    //    func setupToiletMakers(){
    //
    //        for toilet in toilets{
    //            let location = toilet.coordinate
    //
    //
    //        }
    //
    //    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
