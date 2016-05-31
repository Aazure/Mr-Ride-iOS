//
//  BikeHistoryViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/5/30.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit

class BikeHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var historyTableView: UITableView!
    var fruits: [String] = []
    let cellIdentifier = "recordCell"
//    var alphabetizedFruits = [String: [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
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
        
//        fruits = ["Apple", "Pineapple", "Orange", "Blackberry", "Banana", "Pear", "Kiwi", "Strawberry", "Mango", "Walnut", "Apricot", "Tomato", "Almond", "Date", "Melon", "Water Melon", "Lemon", "Coconut", "Fig", "Passionfruit", "Star Fruit", "Clementin", "Citron", "Cherry", "Cranberry"]
//        
//        alphabetizedFruits = alphabetizedArray(fruits)
//        
//        let calender = NSCalendar.currentCalendar()
//        let date = NSDate();
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
//        dateFormatter.timeZone = NSTimeZone()
//        let localDate = dateFormatter.stringFromDate(date)
//        let month = calender.component(NSCalendarUnit.Month, fromDate: date)
//        print(localDate)
//        print(month)
//        
//        
    }
//
//    private func alphabetizedArray(array: [String]) -> [String: [String]]{
//        var result = [String: [String]]()
//        
//        for item in array{
//            
//            let index = item.startIndex.advancedBy(1)
//            let firstLetter = item.substringToIndex(index).uppercaseString
//            
//            if result[firstLetter] != nil{
//                result[firstLetter]!.append(item)
//            }else{
//                result[firstLetter] = [item]
//            }
//            
//        }
//        
//        for(key, value) in result{
//            result[key] = value.sort({(a,b) -> Bool in
//                a.lowercaseString < b.lowercaseString
//            })
//            
//        }
//        return result
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
//        return alphabetizedFruits.keys.count
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let keys = alphabetizedFruits.keys
//        
//        let sortedKeys = keys.sort({ (a,b) -> Bool in
//            a.lowercaseString < b.lowercaseString
//        })
//        
//        let key = sortedKeys[section]
//        
//        if let fruits = alphabetizedFruits[key]{
//            return fruits.count
//        }
//        return 0
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
//
//        let keys = alphabetizedFruits.keys.sort({(a,b) -> Bool in
//            a.lowercaseString < b.lowercaseString
//        })
//        
//        let key = keys[indexPath.section]
//        
//        if let fruits = alphabetizedFruits[key]{
//        
//        let fruit = fruits[indexPath.row]
        
        cell.textLabel?.text = "date | Distance Duration"
//        }
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let keys = alphabetizedFruits.keys.sort({(a,b) -> Bool in
//            a.lowercaseString < b.lowercaseString
//        })
        
        return "Month, Year"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.whiteColor()
        vw.tintColor = UIColor.mrDarkSlateBlueColor()
        
        return vw
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let keys = alphabetizedFruits.keys.sort({(a,b) -> Bool in
//            a.lowercaseString < b.lowercaseString
//        })
//
//        let key = keys[indexPath.section]
//        
//        if let fruits = alphabetizedFruits[key]{
//            print(fruits[indexPath.row])
//        }
//    }
    
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
