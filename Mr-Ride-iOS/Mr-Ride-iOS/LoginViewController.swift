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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorTop = UIColor(red: 99/255.0, green: 215/255.0, blue: 246/255.0, alpha: 1)
        let colorBottom = UIColor(red: 4/255.0, green: 20/255.0, blue: 25/255.0, alpha: 0.5)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 374, width: view.bounds.width, height: 400)
        gradient.colors = [colorTop.CGColor, colorBottom.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 1)
        
        setupTextField()
        
        loginButton.layer.cornerRadius = 30
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func setupTextField(){
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        heightTextField.keyboardType = .NumbersAndPunctuation
        weightTextField.keyboardType = .NumbersAndPunctuation
        
        heightTextField.textColor = UIColor.grayColor()
        weightTextField.textColor = UIColor.grayColor()
        
        heightTextField.text = "Please enter your height"
        weightTextField.text = "Please enter your weight"
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        heightTextField.textColor = UIColor.mrDarkSlateBlueColor()
        weightTextField.textColor = UIColor.mrDarkSlateBlueColor()
        
        if textField === weightTextField{
            weightTextField.text = ""
        }else if textField === heightTextField{
            heightTextField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if textField === weightTextField {
            guard let weight = Double(weightTextField.text!) else {
                weightTextField.text = ""
                ErrorAlert("Invalid Input", errorMessage: "please enter again")
                return
            }
            defaults.setValue(weight, forKey: "weight")
        }
        else if textField === heightTextField {
            guard let height = Double(heightTextField.text!) else {
                heightTextField.text = ""
                ErrorAlert("Invalid Input", errorMessage: "please enter again")
                return
            }
            defaults.setValue(height, forKey: "height")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    private func weightAndHeightDidSet() -> Bool {
        if weightTextField.text == "" || heightTextField.text == "" {
            ErrorAlert("Unable to Login", errorMessage: "please enter your height and weight")
            return false
        } else { return true }
    }
    
    
    func ErrorAlert(errorTitle: String, errorMessage: String) {
        
        let alert = UIAlertController(
            title: NSLocalizedString(errorTitle, comment: ""),
            message: errorMessage,
            preferredStyle: .Alert
        )
        
        let ok = UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .Cancel,
            handler: nil
        )
        
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
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
                print(FBSDKAccessToken.currentAccessToken())
            }
        })
    }
    
    func login(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RevealViewController") as! SWRevealViewController
        appDelegate.window?.rootViewController = homeViewController
        appDelegate.window?.makeKeyAndVisible()
        
        if FBSDKAccessToken.currentAccessToken() != nil{
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, picture.type(large), link, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil{
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(result["name"], forKey: "name")
                    defaults.setObject(result["picture"], forKey: "picture")
                    defaults.setObject(result["link"], forKey: "link")
                    defaults.setObject(result["email"], forKey: "email")
                    defaults.synchronize()
                }
                
            })
        }
        
    }
    
}
