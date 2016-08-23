//
//  LoginViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/5/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Variables

    @IBOutlet weak var tfEmail: MKTextField!
    @IBOutlet weak var tfPassword: MKTextField!
    @IBOutlet weak var btLogin: MKButton!
    @IBOutlet weak var btRegister: MKButton!
    @IBOutlet weak var btForget: MKButton!
    @IBOutlet weak var btFacebook: MKButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var bkNumber:UInt32 = UInt32()
    let permissions = ["public_profile", "email"]
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        activityIndicator.stopAnimating()
    }
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        // Custom navigation bar
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        logoView.contentMode = .ScaleAspectFit
        logoView.alpha = 0.5
        // 4
        let image = UIImage(named: "Icon")
        logoView.image = image
        // 5
        navigationItem.titleView = logoView
        
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
    
        /*
        // Make gif background
        var filePath = NSBundle.mainBundle().pathForResource("Background3", ofType: "gif")
        var gif = NSData(contentsOfFile: filePath!)
        
        var webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.frame = CGRect(x: 0, y: 0, width: dvWidth, height: dvHeight)
        webViewBG.loadData(gif, MIMEType: "image/gif", textEncodingName: nil, baseURL: nil)
        webViewBG.userInteractionEnabled = false;
        webViewBG.opaque = false
        webViewBG.backgroundColor = UIColor.clearColor()
        self.view.addSubview(webViewBG)
        
        
        var filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.blackColor()
        filter.alpha = 0.05
        self.view.addSubview(filter)
        
        self.view.sendSubviewToBack(filter)
        self.view.sendSubviewToBack(webViewBG)
        */
        
        // Make Motion background
        var backgroundImage:UIImageView = UIImageView(frame: CGRect(x: -50, y: -50, width: dvWidth+100, height: dvHeight+100))
        bkNumber = arc4random_uniform(10) + 1
        backgroundImage.image = UIImage(named: "Cappuccino-\(bkNumber).jpg")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -50
        horizontalMotionEffect.maximumRelativeValue = 50
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -50
        verticalMotionEffect.maximumRelativeValue = 50
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        backgroundImage.addMotionEffect(motionEffectGroup)
        
        
        // Make animation background
        //animationBackground(backgroundImage)
        
        // Transparent navigation bar
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clearColor()
        
        // Email textfield
        self.tfEmail.delegate = self
        tfEmail.layer.borderColor = UIColor.clearColor().CGColor
        tfEmail.floatingPlaceholderEnabled = true
        tfEmail.placeholder = "Email Account"
        tfEmail.circleLayerColor = UIColor.MKColor.LightGreen
        tfEmail.tintColor = UIColor.MKColor.Green
        tfEmail.backgroundColor = UIColor(hex: 0xE0E0E0)
        self.view.bringSubviewToFront(tfEmail)
        
        // Password Textfield
        self.tfPassword.delegate = self
        tfPassword.layer.borderColor = UIColor.clearColor().CGColor
        tfPassword.floatingPlaceholderEnabled = true
        tfPassword.placeholder = "Password"
        tfPassword.circleLayerColor = UIColor.MKColor.LightGreen
        tfPassword.tintColor = UIColor.MKColor.Green
        tfPassword.backgroundColor = UIColor(hex: 0xE0E0E0)
        self.view.bringSubviewToFront(tfPassword)
        
        // Login Button
        btLogin.cornerRadius = 40.0
        btLogin.backgroundLayerCornerRadius = 40.0
        btLogin.maskEnabled = false
        btLogin.circleGrowRatioMax = 1.75
        btLogin.rippleLocation = .Center
        btLogin.aniDuration = 0.85
        self.view.bringSubviewToFront(btLogin)
        
        btLogin.layer.shadowOpacity = 0.75
        btLogin.layer.shadowRadius = 3.5
        btLogin.layer.shadowColor = UIColor.blackColor().CGColor
        btLogin.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        // Register Button
        btRegister.cornerRadius = 40.0
        btRegister.backgroundLayerCornerRadius = 40.0
        btRegister.maskEnabled = false
        btRegister.circleGrowRatioMax = 1.75
        btRegister.rippleLocation = .Center
        btRegister.aniDuration = 0.85
        self.view.bringSubviewToFront(btRegister)
        
        btRegister.layer.shadowOpacity = 0.75
        btRegister.layer.shadowRadius = 3.5
        btRegister.layer.shadowColor = UIColor.blackColor().CGColor
        btRegister.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        // Forgot password button
        self.view.bringSubviewToFront(btRegister)
        
        btForget.layer.shadowOpacity = 0.75
        btForget.layer.shadowRadius = 3.5
        btForget.layer.shadowColor = UIColor.blackColor().CGColor
        btForget.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        // Facebook Login
        self.view.bringSubviewToFront(btFacebook)
        
        btFacebook.layer.shadowOpacity = 0.75
        btFacebook.layer.shadowRadius = 3.5
        btFacebook.layer.shadowColor = UIColor.blackColor().CGColor
        btFacebook.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        // Progress icon for logging
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        //Check current user
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            if let user = currentUser {
                if user["isLinkingFacebook"] != nil {
                    if user["isLinkingFacebook"] as! Int == 1 {
                        self.performSegueWithIdentifier("LoginSegue", sender: true)
                    } else {
                        self.performSegueWithIdentifier("LoginSegue", sender: false)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        checkLogin()
        return true;
    }
    
    // MARK: Other Methods
    /*
    func animationBackground(bkImage: UIImageView) {
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height

        let options = UIViewAnimationOptions.CurveEaseInOut
        
        for i in 1...6 {
            UIView.animateWithDuration(1.0, delay: 5.0, options: options, animations: {
                
                //bkImage.frame = CGRectMake(-20, -20, dvWidth+100, dvHeight+100)
                bkImage.image = UIImage(named: "Cappuccino-2")
            
                }, completion: nil)
        }
    }*/
    
    func checkLogin() {
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        // The textfields are not completed
        if (self.tfEmail.text == "") || (self.tfPassword.text == "") {
            var alert = UIAlertController(title: "Login Failed", message: "Please fill your email and password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        PFUser.logInWithUsernameInBackground(tfEmail.text, password:tfPassword.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("LoginSegue", sender: false)
                }
                self.tfEmail.text = ""
                self.tfPassword.text = ""
            } else {
                // The login failed. Check error to see why.
                var alert = UIAlertController(title: "Login Failed", message: "Please check your email or password", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
        tfEmail.placeholder = "Email Account"
        catchLoginEvent()
    }
    
    func catchLoginEvent() {
        btLogin.addTarget(self, action: "btLogin:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func processSignUp() {
        var userEmailAddress = tfEmail.text
        var userPassword = tfPassword.text
        
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress.lowercaseString
        
        // Add email address validation
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        // Create the user
        var user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                self.activityIndicator.stopAnimating()
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("LoginSegue", sender: false)
                }
                self.tfEmail.text = ""
                self.tfPassword.text = ""
            } else {
                self.activityIndicator.stopAnimating()
                if let message: AnyObject = error!.userInfo!["error"] {
                    var alert = UIAlertController(title: "Register Failed", message: message as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        
        tfEmail.placeholder = "Email Account"
    }
    
    // Check validate email
    func validate(value: String) -> Bool {
        var emailRule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        var phoneTest = NSPredicate(format: "SELF MATCHES %@", emailRule)
        return phoneTest.evaluateWithObject(value)
    }
    
    // MARK: IBAction
    
    @IBAction func btLogin(sender: AnyObject) {
        checkLogin()
    }
    @IBAction func btRegister(sender: AnyObject) {
        if (self.tfEmail.text == "") || (self.tfPassword.text == "") {
            var alert = UIAlertController(title: "Register Failed", message: "Please fill your email and password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Build the terms and conditions alert
            let alertController = UIAlertController(title: "Agree to terms and conditions",
                message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(UIAlertAction(title: "I AGREE",
                style: UIAlertActionStyle.Default,
                handler: { alertController in self.processSignUp()})
            )
            alertController.addAction(UIAlertAction(title: "I do NOT agree",
                style: UIAlertActionStyle.Default,
                handler: nil)
            )
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btForgetPass(sender: AnyObject) {
        if tfEmail.text == "" {
            tfEmail.placeholder = "To reset password, please enter email"
        } else {
            if validate(tfEmail.text) {
                tfEmail.textColor = UIColor.blackColor()
                tfEmail.placeholder = "Email Account"
                PFUser.requestPasswordResetForEmailInBackground(tfEmail.text)
                var alert = UIAlertController(title: "Forget Password", message: "Please check your email to continue resetting process", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                tfEmail.placeholder = "Email Account"
            } else {
                tfEmail.textColor = UIColor.redColor()
            }
        }
    }
    
    @IBAction func btFacebook(sender: AnyObject) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    self.performSegueWithIdentifier("LoginSegue", sender: true)
                } else {
                    println("User logged in through Facebook!")
                    self.performSegueWithIdentifier("LoginSegue", sender: true)
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LoginSegue") {
            var accountView:AccountTableViewController = segue.destinationViewController as! AccountTableViewController
            accountView.navigationItem.backBarButtonItem = nil
            accountView.navigationItem.hidesBackButton = true
            accountView.navigationItem.leftBarButtonItem = nil
            
            // Set background as this view's background
            accountView.bkNumber = self.bkNumber
            accountView.isFacebookAccount = sender as! Bool
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        tfEmail.textColor = UIColor.blackColor()
        tfEmail.placeholder = "Email Account"
    }
}
