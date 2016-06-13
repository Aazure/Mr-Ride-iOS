//
//  BikeSidebarTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/24.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit

class BikeSidebarTableViewController: UITableViewController {
    @IBOutlet var BikeSidebarTableView: UITableView!
    @IBOutlet weak var dotHomeLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var dotHIstoryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        homeLabel.font = UIFont.mrTextStyle11Font()
        homeLabel.font = UIFont.mrTextStyle11Font()
        homeLabel.textColor = UIColor.whiteColor()
        dotHomeLabel.hidden = false
        dotHIstoryLabel.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            dotHomeLabel.hidden = false
            dotHIstoryLabel.hidden = true
            homeLabel.textColor = UIColor.whiteColor()
            historyLabel.textColor = UIColor.mrWhite50Color()
        case 1:
            dotHomeLabel.hidden = true
            dotHIstoryLabel.hidden = false
            homeLabel.textColor = UIColor.mrWhite50Color()
            historyLabel.textColor = UIColor.whiteColor()
        default:
            break
        }
    }
    
}