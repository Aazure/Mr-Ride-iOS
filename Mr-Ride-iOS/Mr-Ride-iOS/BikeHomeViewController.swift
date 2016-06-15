//
//  BikeHomeViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/23.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import CoreData

class BikeHomeViewController: UIViewController {
    @IBOutlet weak var totalDistLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var letsRideButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let logo = UIImage(named: "icon-bike")
        let tintImage = logo?.imageWithRenderingMode(.AlwaysTemplate)
        let imageView = UIImageView(image: tintImage)
        imageView.tintColor = UIColor.whiteColor()
        self.navigationItem.titleView = imageView
        
        setLabel()
        totalDistLabel.font = UIFont.mrTextStyle8Font()
        totalCountLabel.font = UIFont.mrTextStyle9Font()
        avgSpeedLabel.font = UIFont.mrTextStyle9Font()
        letsRideButton.titleLabel?.font = UIFont.mrTextStyle9Font()
        letsRideButton.layer.cornerRadius = 30
        letsRideButton.layer.borderWidth = 1
        letsRideButton.layer.borderColor = UIColor.whiteColor().CGColor
        letsRideButton.layer.shadowColor = UIColor.mrBlack25Color().CGColor
        letsRideButton.layer.shadowRadius = 2
        letsRideButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        letsRideButton.layer.masksToBounds = true
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    
    func setLabel(){
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
            let distanceStr = NSString(format: "%.2f", distance*0.01)
            self.totalDistLabel.text = String(distanceStr) + " km"
            let speedStr = NSString(format: "%.2f", distance / duration * 3.6)
            self.avgSpeedLabel.text = String(speedStr) + " km / h"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
