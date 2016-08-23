//
//  AccountTableViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/6/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Variables
    
    var tfFullName:MKTextField = MKTextField()
    var tfEmail:MKTextField = MKTextField()
    var tfPhone:MKTextField = MKTextField()
    var smGender:UISegmentedControl = UISegmentedControl()
    var dpkBirthday:UIDatePicker = UIDatePicker()
    var tfPassword:MKTextField = MKTextField()
    var tfConfirmPass:MKTextField = MKTextField()
    var linkFacebookButton:MKButton = MKButton()
    var backButton:MKButton = MKButton()
    var saveButton:MKButton = MKButton()
    
    var currentUser = PFUser.currentUser()
    var bkNumber:UInt32 = UInt32()
    var isFacebookAccount:Bool = Bool()
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tfEmail.delegate = self
        tfFullName.delegate = self
        tfConfirmPass.delegate = self
        tfPassword.delegate = self
        tfPhone.delegate = self
        
        // Create notification about sharing information
        var alert = UIAlertController(title: "Sharing Personal Information", message: "Welcome. We're happy when you register to our application. To be our membership, please fill your personal information (Full name, Telephone and Birthday). When become our membership, you can take our voucher from any store.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

        // Add Left Button on Navigation Bar
        self.addLeftNavItemOnView()

        println(currentUser)
        
        // Config Tableview
        tableView.separatorColor = UIColor.blackColor()
            // Add blur effect to background image
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            var bgImage = UIImageView(image: UIImage(named: "Cappuccino-\(bkNumber).jpg"))
            blurEffectView.frame = bgImage.frame
            bgImage.addSubview(blurEffectView)
            tableView.backgroundView = bgImage
            
            //if you want translucent vibrant table view separator lines
            tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        }
        
        // Asychonize with parse server
        currentUser?.fetch()
    }
    
    // MARK: Other Methods

    func addLeftNavItemOnView (){
        // hide default navigation bar button item
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backButton.backgroundColor = UIColor.MKColor.Green
        backButton.cornerRadius = 20.0
        backButton.backgroundLayerCornerRadius = 20.0
        backButton.maskEnabled = false
        backButton.circleGrowRatioMax = 1.75
        backButton.rippleLocation = .Center
        backButton.aniDuration = 0.85
        backButton.layer.shadowOpacity = 0.75
        backButton.layer.shadowRadius = 3.5
        backButton.layer.shadowColor = UIColor.blackColor().CGColor
        backButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        backButton.setImage(UIImage(named: "Back"), forState: UIControlState.Normal)
        //backButton.setTitle("<", forState: UIControlState.Normal)
        //backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)

        saveButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        saveButton.backgroundColor = UIColor.MKColor.Blue
        saveButton.cornerRadius = 20.0
        saveButton.backgroundLayerCornerRadius = 20.0
        saveButton.maskEnabled = false
        saveButton.circleGrowRatioMax = 1.75
        saveButton.rippleLocation = .Center
        saveButton.aniDuration = 0.85
        saveButton.layer.shadowOpacity = 0.75
        saveButton.layer.shadowRadius = 3.5
        saveButton.layer.shadowColor = UIColor.blackColor().CGColor
        saveButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        saveButton.setImage(UIImage(named: "Save"), forState: UIControlState.Normal)
        //backButton.setTitle("<", forState: UIControlState.Normal)
        //backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        saveButton.addTarget(self, action: "saveButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: saveButton)
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        
        self.navigationItem.title = ""
    }
    
    func backButtonClick(sender:UIButton!){
        PFUser.logOut()
        var loginView:LoginViewController = LoginViewController()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveButtonClick(sender:UIButton!){
        // MARK: Check validation and add Indicator
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        // Config Indicator
        var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: dvWidth/2 - 10, y: 0, width: 20, height: 20))
        activityIndicator.color = UIColor.blackColor()
        // Progress icon for logging
        self.view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
        //activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        if tfPassword.text != "" || tfConfirmPass.text != "" {
            if (tfPassword.text != tfConfirmPass.text) || (validate(tfEmail.text) == false) {
                activityIndicator.stopAnimating()
                tfPassword.textColor = UIColor.redColor()
                tfConfirmPass.textColor = UIColor.redColor()
            } else {
                updateUserPassword()
                updateUserInfo(activityIndicator)
            }
        } else {
            updateUserInfo(activityIndicator)
        }
    }
    
    func updateUserInfo(activityIndicator: UIActivityIndicatorView) {
        // MARK: Update user
        if let user = currentUser as PFUser? {
            // Update the existing parse object
            if tfFullName.text != "" {
                user["CustomerFullName"] = tfFullName.text
            }
            if tfPhone.text != "" {
                user["CustomerTelephone"] = tfPhone.text.toInt()
            }
            if smGender.selectedSegmentIndex == 0 {
                user["CustomerGender"] = 0
            } else if smGender.selectedSegmentIndex == 1 {
                user["CustomerGender"] = 1
            }
            user["CustomerBirthday"] = dpkBirthday.date
            
            // Save the data in background
            user.saveInBackground()

            // Update currentUser
            currentUser?.fetchInBackgroundWithBlock({ (success, error) -> Void in
                if (success != nil) {
                    activityIndicator.stopAnimating()
                }
            })
        }
    }
    
    func updateUserPassword() {
        if let user = currentUser as PFUser? {
            user["password"] = tfPassword.text
            user.saveInBackground()
            // Update currentUser
            currentUser?.fetchInBackground()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Setting TableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 5
        } else if section == 1 {
            return 2
        } else {
            return 1
        }
    }

    
    override func tableView(tableViewv: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.backgroundColor = UIColor(hex: 0xE0E0E0)
        cell.backgroundColor = UIColor.clearColor()
        //cell.userInteractionEnabled = false
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // Fullname textfield
                tfFullName.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 50)
                tfFullName.layer.borderColor = UIColor.clearColor().CGColor
                tfFullName.floatingPlaceholderEnabled = true
                tfFullName.placeholder = "Full Name (Optional)"
                tfFullName.circleLayerColor = UIColor.MKColor.LightGreen
                tfFullName.tintColor = UIColor.MKColor.Green
                //tfFullName.backgroundColor = UIColor(hex: 0xE0E0E0)
                tfFullName.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(tfFullName)
                // Get data from Parse if exist
                if let user = currentUser {
                    if user["CustomerFullName"] != nil {
                        tfFullName.text = user["CustomerFullName"] as! String
                    }
                }
            }
            if indexPath.row == 1 {
                // Email textfield
                tfEmail.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 50)
                tfEmail.layer.borderColor = UIColor.clearColor().CGColor
                tfEmail.floatingPlaceholderEnabled = true
                tfEmail.placeholder = "Email"
                tfEmail.circleLayerColor = UIColor.MKColor.LightGreen
                tfEmail.tintColor = UIColor.MKColor.Green
                //tfEmail.backgroundColor = UIColor(hex: 0xE0E0E0)
                tfEmail.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(tfEmail)
                // Get data from Parse if exist
                if let user = currentUser {
                    if user["email"] != nil {
                        tfEmail.text = user["email"] as! String
                    }
                }
            }
            if indexPath.row == 2 {
                // Phone textfield
                tfPhone.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 50)
                tfPhone.layer.borderColor = UIColor.clearColor().CGColor
                tfPhone.keyboardType = UIKeyboardType.NumberPad
                tfPhone.floatingPlaceholderEnabled = true
                tfPhone.placeholder = "Phone number (Optional)"
                tfPhone.circleLayerColor = UIColor.MKColor.LightGreen
                tfPhone.tintColor = UIColor.MKColor.Green
                //tfPhone.backgroundColor = UIColor(hex: 0xE0E0E0)
                tfPhone.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(tfPhone)
                if let user = currentUser {
                    if user["CustomerTelephone"] != nil {
                        tfPhone.text = "0" + String(user["CustomerTelephone"] as! Int)
                    }
                }
            }
            if indexPath.row == 3 {
                // Label Gender
                var genderLabel:UILabel = UILabel(frame: CGRect(x: 5, y: 0, width: cell.frame.width/2, height: 20))
                genderLabel.font = UIFont.boldSystemFontOfSize(10.0)
                genderLabel.textColor = UIColor.lightGrayColor()
                genderLabel.text = "Gender"
                cell.contentView.addSubview(genderLabel)
                // Switcher
                let items = ["Female", "Male"]
                smGender = UISegmentedControl(items: items)
                //smGender.selectedSegmentIndex = 0
                smGender.frame = CGRect(x: 0, y: genderLabel.frame.height, width: cell.frame.width, height: 29)
                smGender.tintColor = UIColor.MKColor.LightGreen
                smGender.layer.borderColor = UIColor.clearColor().CGColor
                //smGender.backgroundColor = UIColor(hex: 0xE0E0E0)
                smGender.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(smGender)
                // Get data from Parse if exist
                if let user = currentUser {
                    if user["CustomerGender"] != nil {
                        if user["CustomerGender"] as! Int == 0 {
                            smGender.selectedSegmentIndex = 0
                        } else {
                            smGender.selectedSegmentIndex = 1
                        }
                    }
                }
            }
            if indexPath.row == 4 {
                // Label Birthday
                var birthLabel:UILabel = UILabel(frame: CGRect(x: 5, y: 0, width: cell.frame.width/2, height: 20))
                birthLabel.font = UIFont.boldSystemFontOfSize(10.0)
                birthLabel.textColor = UIColor.lightGrayColor()
                birthLabel.text = "Birthday (Optional)"
                cell.contentView.addSubview(birthLabel)
                // Date Picker
                dpkBirthday = UIDatePicker(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 40));
                dpkBirthday.datePickerMode = UIDatePickerMode.Date;
                cell.contentView.addSubview(dpkBirthday);
                // Get data from Parse if exist
                if let user = currentUser {
                    if let date = user["CustomerBirthday"] as? NSDate {
                        dpkBirthday.date = date
                    }
                }
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Password textfield
                tfPassword.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 50)
                tfPassword.layer.borderColor = UIColor.clearColor().CGColor
                tfPassword.floatingPlaceholderEnabled = true
                tfPassword.placeholder = "Password"
                tfPassword.circleLayerColor = UIColor.MKColor.LightGreen
                tfPassword.tintColor = UIColor.MKColor.Green
                tfPassword.secureTextEntry = true
                //tfPassword.backgroundColor = UIColor(hex: 0xE0E0E0)
                tfPassword.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(tfPassword)
            }
            if indexPath.row == 1 {
                // Confirm Password textfield
                tfConfirmPass.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 50)
                tfConfirmPass.layer.borderColor = UIColor.clearColor().CGColor
                tfConfirmPass.floatingPlaceholderEnabled = true
                tfConfirmPass.placeholder = "Confirm Password"
                tfConfirmPass.circleLayerColor = UIColor.MKColor.LightGreen
                tfConfirmPass.tintColor = UIColor.MKColor.Green
                tfConfirmPass.secureTextEntry = true
                //tfConfirmPass.backgroundColor = UIColor(hex: 0xE0E0E0)
                tfConfirmPass.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(tfConfirmPass)
            }
        } else {
            if indexPath.row == 0 {
                linkFacebookButton.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 50)
                linkFacebookButton.backgroundColor = UIColor.MKColor.Blue
                //linkFacebookButton.cornerRadius = 20.0
                //linkFacebookButton.backgroundLayerCornerRadius = 20.0
                //linkFacebookButton.maskEnabled = false
                //linkFacebookButton.circleGrowRatioMax = 1.75
                //linkFacebookButton.rippleLocation = .Center
                //linkFacebookButton.aniDuration = 0.85
                linkFacebookButton.layer.shadowOpacity = 0.75
                linkFacebookButton.layer.shadowRadius = 3.5
                linkFacebookButton.layer.shadowColor = UIColor.blackColor().CGColor
                linkFacebookButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
                if isFacebookAccount == false {
                    linkFacebookButton.setTitle("Link Facebook Account", forState: UIControlState.Normal)
                } else {
                    linkFacebookButton.setTitle("Unlink Facebook Account", forState: UIControlState.Normal)
                }
                linkFacebookButton.titleLabel?.font = UIFont(name: "Helvetica-Regular", size: 22)
                linkFacebookButton.addTarget(self, action: "linkFaceBook:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.contentView.addSubview(linkFacebookButton)
            }
        }
        return cell
    }
    
    func linkFaceBook(sender:UIButton) {
        if isFacebookAccount == false {
            isFacebookAccount = true
            if !PFFacebookUtils.isLinkedWithUser(currentUser!) {
                PFFacebookUtils.linkUserInBackground(currentUser!, withReadPermissions: nil, block: {
                    (succeeded, error) -> Void in
                    if succeeded {
                        println("Woohoo, user is linked with Facebook!")
                        self.linkFacebookButton.setTitle("Unlink Facebook Account", forState: UIControlState.Normal)
                    }
                })
            }
            if let user = currentUser as PFUser? {
                user["isLinkingFacebook"] = 1
                user.saveInBackground()
            }
        } else {
            isFacebookAccount = false
            PFFacebookUtils.unlinkUserInBackground(currentUser!, block: {
                (succeeded, error) -> Void in
                if succeeded {
                    println("The user is no longer associated with their Facebook account.")
                    var alert = UIAlertController(title: "Success", message: "This M-Coffee account is no longer associated with Facebook account", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.linkFacebookButton.setTitle("Link Facebook Account", forState: UIControlState.Normal)
                }
            })
            if let user = currentUser as PFUser? {
                user["isLinkingFacebook"] = 0
                user.saveInBackground()
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 4 {
            return 210
        } else { return 50 }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionHeaderView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        sectionHeaderView.backgroundColor = UIColor.MKColor.LightGreen
        
        var headerLabel:UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: sectionHeaderView.frame.size.width, height: 20))
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.font = UIFont(name: "", size: 20)
        sectionHeaderView.addSubview(headerLabel)
        
        if section == 0 {
            headerLabel.text = "Your Information"
            return sectionHeaderView
        }
        if section == 1 {
            headerLabel.text = "Change Password"
            return sectionHeaderView
        }
        if section == 2{
            headerLabel.text = "Social Linking"
            return sectionHeaderView
        }
        return sectionHeaderView
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.tableView.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if validate(tfEmail.text) == false {
            tfEmail.textColor = UIColor.redColor()
        } else {
            tfEmail.textColor = UIColor.blackColor()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func validate(value: String) -> Bool {
        var emailRule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        var phoneTest = NSPredicate(format: "SELF MATCHES %@", emailRule)
        return phoneTest.evaluateWithObject(value)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
