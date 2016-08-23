//
//  MenuViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/8/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var browseButton:MKButton = MKButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightNavItemOnView()
        transparentNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func transparentNavigationBar() {
        // Transparent navigation bar
        //let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        //bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        //bar.shadowImage = UIImage()
        //bar.backgroundColor = UIColor.clearColor()
    }
    
    func addRightNavItemOnView(){
        // hide default navigation bar button item
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        browseButton.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        browseButton.backgroundColor = UIColor.MKColor.Green
        browseButton.layer.shadowOpacity = 0.75
        browseButton.layer.shadowRadius = 3.5
        browseButton.layer.shadowColor = UIColor.blackColor().CGColor
        browseButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        browseButton.setTitle("Browse Menu", forState: UIControlState.Normal)
        browseButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        browseButton.addTarget(self, action: "browseClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: browseButton)
        //var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Browse Menu", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonClick:"))
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
    }
    
    func browseClick(sender:UIButton!) {
        self.performSegueWithIdentifier("BrowseMenuSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "BrowseMenuSegue") {
            var menuTableView:MenuTableViewController = segue.destinationViewController as! MenuTableViewController
            menuTableView.navigationItem.backBarButtonItem = nil
            menuTableView.navigationItem.hidesBackButton = true
            menuTableView.navigationItem.leftBarButtonItem = nil
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
