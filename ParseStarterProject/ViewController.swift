/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registeredText: UILabel!
    
    var signupActive = true
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUpButtonPress(sender: AnyObject) {
        if signupActive
        {
            signUp()
        }
        else
        {
            logIn()
        }
    }
    
    func signUp()
    {
        // Unsuccessful Sign Up
        if username.text == "" || password.text == ""
        {
            displayAlert("Error in form", message: "Please enter a username and password")
        }
            
            // Successful sign up
        else
        {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            
            // hides it when we stop it each time.
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            
            self.view.addSubview(activityIndicator)
            
            // begin showing activity indicator
            activityIndicator.startAnimating()
            
            
            // Stops user interaction with view
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            
            var errorMessage = "Please try again later"
            
            user.signUpInBackgroundWithBlock {
                (succeess: Bool, error: NSError?) -> Void in
                
                // stop Activity Indicator
                self.activityIndicator.stopAnimating()
                
                // Lets user use the app again
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if let error = error
                {
                    if let errorString = error.userInfo["error"] as? String
                    {
                        errorMessage = errorString
                    }
                    
                    // Show the errorString somewhere and let the user try again.
                    self.displayAlert("Failed Sign Up", message: errorMessage)
                    
                }
                else
                {
                    // Hooray! Let them use the app now.
                    
                    self.performSegueWithIdentifier("login", sender: self)
                }
            }
            
        }
    }
    
    func logIn()
    {
        // Unsuccessful log in
        if username.text == "" || password.text == ""
        {
            displayAlert("Error in form", message: "Please enter a username and password")
        }
            
            // Successful log in
        else
        {
            var errorMessage = "Please try again later"
            PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                
                if user != nil
                {
                    //                    self.displayAlert("Success", message: "Good Job")
                    self.performSegueWithIdentifier("login", sender: self)
                }
                else
                {
                    // The login failed. Check error to see why.
                    if let error = error
                    {
                        if let errorString = error.userInfo["error"] as? String
                        {
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed Log In", message: errorMessage)
                    }
                    else
                    {
                        // Not sure what this would be?
                    }
                }
                
            }
        }
    }
    
    
    @IBAction func logInButtonPress(sender: AnyObject) {
        if signupActive
        {
            // Switch to Login Mode
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            registeredText.text = "Not registered?"
            logInButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
        }
        else
        {
            // Switch to Sign Up Mode
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            registeredText.text = "Already registered?"
            logInButton.setTitle("Log In", forState: UIControlState.Normal)
            signupActive = true
        }
    }
    
    func displayAlert(title: String, message: String)
    {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
