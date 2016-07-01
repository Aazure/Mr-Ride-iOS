//
//  LoginViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/7/1.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorTop = UIColor(red: 99/255.0, green: 215/255.0, blue: 246/255.0, alpha: 1)
        let colorBottom = UIColor(red: 4/255.0, green: 20/255.0, blue: 25/255.0, alpha: 0.5)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 374, width: view.bounds.width, height: 400)
        gradient.colors = [colorTop.CGColor, colorBottom.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 1)

        // Do any additional setup after loading the view.
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
