//
//  BikeHistoryViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/30.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Charts

class BikeHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var sectionLabel: UILabel!
    let cellIdentifier = "recordCell"
    var fetchedResultsController: NSFetchedResultsController!
    var dateArray: [String] = []
    var distanceArray: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeFetchedResultsController()
        setupNavigation()
        getDataForChart()
        setChart(self.dateArray, values: self.distanceArray)
        
        
        let colorTop = UIColor(red: 99/255.0, green: 215/255.0, blue: 246/255.0, alpha: 1)
        let colorBottom = UIColor(red: 4/255.0, green: 20/255.0, blue: 25/255.0, alpha: 0.5)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 374, width: 400, height: 400)
        gradient.colors = [colorTop.CGColor, colorBottom.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 1)
        
        historyTableView.backgroundColor = UIColor.clearColor()
        historyTableView.separatorColor = UIColor.clearColor()
        historyTableView.separatorStyle = .SingleLine
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func setupNavigation(){
        self.navigationItem.title = "History"
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
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
        let gradientColors = [ UIColor.mrBrightBlueColor().CGColor, UIColor.mrTurquoiseBlueColor().CGColor] // Colors of the gradient
        let colorLocations:[CGFloat] = [0.0, 0.05] // Positioning of the gradient
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
        lineChartView.rightAxis.gridColor = .whiteColor()
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.gridColor = .clearColor()
        lineChartView.xAxis.labelTextColor = .whiteColor()
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.xAxis.axisLineColor = .whiteColor()
        lineChartView.legend.enabled = false
        lineChartView.descriptionText = ""
        lineChartView.userInteractionEnabled = false
        
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
    }
    
    func initalizeFetchedResultsController(){
        let fetchRequest = NSFetchRequest(entityName: "Record")
        let fetchSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [fetchSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dateForSection", cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Failed to initialize FetchedResultsControllr:\(error)")
        }
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath){
        let record = fetchedResultsController.objectAtIndexPath(indexPath)
        
        let date = record.valueForKey("date") as? NSDate
        let calender = NSCalendar.currentCalendar()
        let dateComponents = calender.components([.Day, .Month, .Year], fromDate: date!)
        
        let distance = record.valueForKey("distance") as? Double
        let distanceKm = distance! * 0.01
        let distanceStr = NSString(format: "%.2f", distanceKm)
        
        var  duration = record.valueForKey("duration") as! Double
        let hours = UInt8(duration / 3600.0)
        duration -= (NSTimeInterval(hours) * 3600)
        let minutes = UInt8(duration / 60.0)
        duration -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(duration)
        duration -= NSTimeInterval(seconds)
        let fraction = UInt8(duration * 100)
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        let durationStr = "\(strHours):\(strMinutes):\(strSeconds).\(strFraction)"
        
        cell.textLabel?.text = "\(dateComponents.day)th | \(distanceStr) km \(durationStr)"
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        historyTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        historyTableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            historyTableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            historyTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        default: break
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections where sections.count > 0{
            return sections[section].numberOfObjects
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController?.sections where sections.count > 0 {
            return sections[section].name
        }else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("header") as! CustomHeader
        if let sections = fetchedResultsController?.sections where sections.count > 0 {
            headerCell.headerLabel.text = sections[section].name
        }else {
            return nil
        }
        
        return headerCell
    }
    
    //    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let footerCell = tableView.dequeueReusableCellWithIdentifier("footer") as! CustomFooter
    //
    //        return footerCell
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let record = fetchedResultsController.objectAtIndexPath(indexPath)
        let date = record.valueForKey("date") as! NSDate
        let distance = record.valueForKey("distance") as! Double
        let duration = record.valueForKey("duration") as! Double
        let routes = record.valueForKey("routes")?.allObjects as? [Route]
        var locationArray: [CLLocationCoordinate2D] = []
        for route in routes!{
            locationArray.append(CLLocationCoordinate2D(latitude: Double(route.latitude!), longitude: Double(route.longitude!)))
        }
        
        print("history: \(routes)")
        let analysisVC = self.storyboard?.instantiateViewControllerWithIdentifier("AnalysisPage") as! BikeAnalysisViewController
        analysisVC.date = date
        analysisVC.distance = distance
        analysisVC.duration = duration
        analysisVC.routes = locationArray
        analysisVC.isFromTable = true
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let convertedDate = dateFormatter.stringFromDate(date)
        analysisVC.navigationItem.title = convertedDate
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.pushViewController(analysisVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
