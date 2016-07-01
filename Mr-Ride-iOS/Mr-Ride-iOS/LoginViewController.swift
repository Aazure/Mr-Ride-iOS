//
//  LoginViewController.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/7/1.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorTop = UIColor(red: 99/255.0, green: 215/255.0, blue: 246/255.0, alpha: 1)
        let colorBottom = UIColor(red: 4/255.0, green: 20/255.0, blue: 25/255.0, alpha: 0.5)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 374, width: view.bounds.width, height: 400)
        gradient.colors = [colorTop.CGColor, colorBottom.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 1)
        
        loginButton.layer.cornerRadius = 30

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func fbButtonTapped(sender: UIButton) {
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile", "email"], fromViewController: self, handler: { (result,error) -> Void in
            if error != nil{
                print(error.localizedDescription)
                return
            }else if result.isCancelled{
                return
            }else{
                self.login()
            }
        })
    }

    func login(){
        let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RevealViewController")
        self.view.window?.rootViewController = homeViewController
        
        if FBSDKAccessToken.currentAccessToken() != nil{
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, picture.type(large), link, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil{
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(result["name"], forKey: "name")
                    defaults.setObject(result["picture"], forKey: "picture")
                    defaults.setObject(result["link"], forKey: "link")
                    defaults.setObject(result["email"], forKey: "email")
                    defaults.synchronize()
                    print(defaults.objectForKey("link"))
                    
                    print("FBdata saved!")
                }
                
            })
        }
        
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
