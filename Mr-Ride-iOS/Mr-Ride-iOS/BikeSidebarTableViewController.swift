//
//  BikeSidebarTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/24.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import MapKit

class BikeSidebarTableViewController: UITableViewController {
    @IBOutlet var BikeSidebarTableView: UITableView!
    @IBOutlet weak var dotHomeLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var dotHIstoryLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var dotMapLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeLabel.font = UIFont.mrTextStyle11Font()
        homeLabel.font = UIFont.mrTextStyle11Font()
        homeLabel.textColor = UIColor.whiteColor()
        dotHomeLabel.hidden = false
        dotHIstoryLabel.hidden = true
        dotMapLabel.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TrackingManager.sharedManager.createTrackingScreenView("view_in_menu")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            dotHomeLabel.hidden = false
            dotHIstoryLabel.hidden = true
            dotMapLabel.hidden = true
            homeLabel.textColor = UIColor.whiteColor()
            historyLabel.textColor = UIColor.mrWhite50Color()
            mapLabel.textColor = UIColor.mrWhite50Color()
            TrackingManager.sharedManager.createTrackingEvent("menu", action: "select_home_in_menu")
        case 1:
            dotHomeLabel.hidden = true
            dotHIstoryLabel.hidden = false
            dotMapLabel.hidden = true
            homeLabel.textColor = UIColor.mrWhite50Color()
            historyLabel.textColor = UIColor.whiteColor()
            mapLabel.textColor = UIColor.mrWhite50Color()
            TrackingManager.sharedManager.createTrackingEvent("menu", action: "select_select_history_in_menuhome_in_menu")
        case 2:
            dotHomeLabel.hidden = true
            dotHIstoryLabel.hidden = true
            dotMapLabel.hidden = false
            homeLabel.textColor = UIColor.mrWhite50Color()
            historyLabel.textColor = UIColor.mrWhite50Color()
            mapLabel.textColor = UIColor.whiteColor()
            TrackingManager.sharedManager.createTrackingEvent("menu", action: "select_map_in_menu")
            
        default:
            break
        }
    }
    
}