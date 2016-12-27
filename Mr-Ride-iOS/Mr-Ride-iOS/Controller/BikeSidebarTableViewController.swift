//
//  BikeSidebarTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/24.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit
import FBSDKCoreKit

class BikeSidebarTableViewController: UITableViewController {
    @IBOutlet var BikeSidebarTableView: UITableView!
    @IBOutlet weak var dotHomeLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var dotHistoryLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var dotMapLabel: UILabel!
}

// MARK: - Setup
extension BikeSidebarTableViewController{
    func setupLabel(){
        homeLabel.font = UIFont.mrTextStyle11Font()
        homeLabel.textColor = UIColor.whiteColor()
        dotHomeLabel.hidden = false
        dotHistoryLabel.hidden = true
        dotMapLabel.hidden = true
    }
    
    func setupLogoutButton(){
        let button = UIButton()
        button.frame = CGRectMake(55, 586, 150, 32)
        button.backgroundColor = UIColor.mrBlack25Color()
        button.tintColor = UIColor.whiteColor()
        button.layer.cornerRadius = 4
        button.setTitle("Log Out", forState: .Normal)
        button.titleLabel?.font = UIFont(name: "SFUIText-Regular", size: 12)
        button.addTarget(self, action: #selector(self.logout), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(button)
    }
}

// MARK: - View LifeCycle
extension BikeSidebarTableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupLogoutButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TrackingManager.sharedManager.createTrackingScreenView("view_in_menu")
    }
}

// MARK: - TableView
extension BikeSidebarTableViewController{
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
            dotHistoryLabel.hidden = true
            dotMapLabel.hidden = true
            homeLabel.textColor = UIColor.whiteColor()
            historyLabel.textColor = UIColor.mrWhite50Color()
            mapLabel.textColor = UIColor.mrWhite50Color()
            TrackingManager.sharedManager.createTrackingEvent("menu", action: "select_home_in_menu")
        case 1:
            dotHomeLabel.hidden = true
            dotHistoryLabel.hidden = false
            dotMapLabel.hidden = true
            homeLabel.textColor = UIColor.mrWhite50Color()
            historyLabel.textColor = UIColor.whiteColor()
            mapLabel.textColor = UIColor.mrWhite50Color()
            TrackingManager.sharedManager.createTrackingEvent("menu", action: "select_select_history_in_menuhome_in_menu")
        case 2:
            dotHomeLabel.hidden = true
            dotHistoryLabel.hidden = true
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

// MARK: - Logout
extension BikeSidebarTableViewController{
    func logout(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        appDelegate.window?.rootViewController = loginViewController
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "name")
    }
}