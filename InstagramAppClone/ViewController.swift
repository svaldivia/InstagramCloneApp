//
//  ViewController.swift
//  InstagramAppClone
//
//  Created by Sebastian Valdivia on 2016-04-13.
//  Copyright © 2016 Sebastian Valdivia. All rights reserved.
//

import UIKit
import Parse

@available(iOS 8.0, *)
class ViewController: UIViewController {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var signUpActive = true
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var registeredLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            self.displayAlert("Error in form", message: "Please enter a username and password")
            
        } else {
            
            activityIndicator =  UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            if signUpActive == true {
                let user = PFUser()
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock({ (success, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        //Sign up successful
                        
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Failed SignUp!", message: errorMessage)
                        
                    }
                    
                })
            } else {
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        //Logged In!
                        self.performSegueWithIdentifier("login", sender: self)
                    } else {
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Failed LogIn!", message: errorMessage)
                    }
                })
            }
            
            
            
            
        }
        
    }
    @IBAction func login(sender: AnyObject) {
        
        if signUpActive == true {
            
            submitButton.setTitle("Log In", forState: UIControlState.Normal)
            
            registeredLabel.text = "Not registered?"
            
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signUpActive = false
            
        } else {
            submitButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredLabel.text = "Already registered?"
            
            loginButton.setTitle("Log In", forState: UIControlState.Normal)
            
            signUpActive = true
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil  && PFUser.currentUser()?.objectId != nil {
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

