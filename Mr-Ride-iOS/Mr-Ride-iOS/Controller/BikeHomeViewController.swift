//
//  BikeHomeViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/23.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import CoreData
import Amplitude_iOS
import Charts

class BikeHomeViewController: UIViewController{
    @IBOutlet weak var totalDistLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var letsRideButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    @IBOutlet weak var lineChartView: LineChartView!
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var dateArray: [String] = []
    var distanceArray: [Double] = []
    
   }

// MARK: - Setup
extension BikeHomeViewController {
    func setupNavigation(){
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let logo = UIImage(named: "icon-bike")
        let tintImage = logo?.imageWithRenderingMode(.AlwaysTemplate)
        let imageView = UIImageView(image: tintImage)
        imageView.tintColor = UIColor.whiteColor()
        self.navigationItem.titleView = imageView
    }
    
    func setupSidebar(){
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func setupLabel(){
        moc.performBlock{
            let results = self.moc.countForFetchRequest(NSFetchRequest(entityName: "Record"), error: nil)
            self.totalCountLabel.text = String(results) + " times"
            
            let request = NSFetchRequest(entityName: "Record")
            let records = try? self.moc.executeFetchRequest(request)
            var distance = 0.0
            var duration = 0.0
            for record in records! {
                distance += record.valueForKey("distance") as! Double
                duration += record.valueForKey("duration") as! Double
            }
            let distanceStr = NSString(format: "%.2f", distance*0.001)
            self.totalDistLabel.text = String(distanceStr) + " km"
            let speedStr = NSString(format: "%.2f", distance / duration * 3.6)
            self.avgSpeedLabel.text = String(speedStr) + " km / h"
            
            self.totalDistLabel.font = UIFont.mrTextStyle8Font()
            self.totalCountLabel.font = UIFont.mrTextStyle9Font()
            self.avgSpeedLabel.font = UIFont.mrTextStyle9Font()
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]){
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count{
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "km")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        
        //fill gradient for the curve
        let gradientColors = [ UIColor.mrRobinsEggBlue0Color().CGColor, UIColor.mrWaterBlueColor().CGColor] // Colors of the gradient
        let colorLocations:[CGFloat] = [0.0, 0.2] // Positioning of the gradient
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations) // Gradient Object
        lineChartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0)
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.lineWidth = 0.0
        
        
        lineChartDataSet.drawCirclesEnabled = false //remove the point circle
        lineChartDataSet.mode = .CubicBezier //make the line to be curve
        lineChartDataSet.drawValuesEnabled = false       //remove value label on each point
        
        //make chartview not scalable and remove the interaction line
        lineChartView.setScaleEnabled(false)
        lineChartView.userInteractionEnabled = false
        
        lineChartView.backgroundColor = UIColor.clearColor()
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.rightAxis.labelTextColor = .clearColor()
        lineChartView.rightAxis.gridColor = .clearColor()
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.gridColor = .clearColor()
        lineChartView.xAxis.labelTextColor = .clearColor()
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.xAxis.axisLineColor = .clearColor()
        lineChartView.legend.enabled = false
        lineChartView.descriptionText = ""
        
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
    }
    
    func setupLetsRideButton(){
        letsRideButton.titleLabel?.font = UIFont.mrTextStyle9Font()
        letsRideButton.layer.cornerRadius = 30
        letsRideButton.layer.borderWidth = 1
        letsRideButton.layer.borderColor = UIColor.whiteColor().CGColor
        letsRideButton.layer.shadowColor = UIColor.mrBlack25Color().CGColor
        letsRideButton.layer.shadowRadius = 2
        letsRideButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        letsRideButton.layer.masksToBounds = true
    }

}

// MARK: - View LifeCycle
extension BikeHomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupLabel()
        setupLetsRideButton()
        setupSidebar()
        getDataForChart()
        setChart(self.dateArray, values: self.distanceArray)
        Amplitude.instance().logEvent("view_in_home")
    }
}

// MARK: - Data
extension BikeHomeViewController {
    func getDataForChart(){
        let mocChart = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Record")
        let records = try? mocChart.executeFetchRequest(request)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        for record in records!{
            if let dateTmp = record.valueForKey("date") as? NSDate{
                self.dateArray.append(dateFormatter.stringFromDate(dateTmp))
                print(self.dateArray)
            }
            if let distanceTmp = record.valueForKey("distance") as? Double{
                self.distanceArray.append(distanceTmp / 1000)
                print(self.distanceArray)
            }
        }
        
    }
}

// MARK: - Action
extension BikeHomeViewController {
    
    //    func showHomePage(){
    //        for subview in view.subviews where subview is UILabel{
    //            subview.hidden = false
    //        }
    //        letsRideButton.hidden = false
    //    }
    
    //    private var record: BikeRecordViewController!
    //
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if let recordVC = segue.destinationViewController as? BikeRecordViewController where segue.identifier == "recordSegue"{
    //            self.record = recordVC
    //            record.delegation = self
    //
    //        }
    //    }
    
    
    @IBAction func buttonTapped(sender: UIButton) {
        TrackingManager.sharedManager.createTrackingEvent("Home", action: "select_ride_in_home")
        //
        ////        let recordVC = self.storyboard!.instantiateViewControllerWithIdentifier("RecordPage") as! BikeRecordViewController
        ////        recordVC.delegation = self
        ////        recordVC.test = "YA~~~!!"
        //
        ////        self.navigationController!.presentViewController(recordVC, animated: true, completion: nil)
        //
        //        for subview in view.subviews where subview is UILabel{
        //            subview.hidden = true
        //        }
        //        letsRideButton.hidden = true
    }
}
