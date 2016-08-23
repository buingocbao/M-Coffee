//
//  MenuTableViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/8/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class MenuTableViewController: PFQueryTableViewController {
    
    // MARK: Variables
    var backButton:MKButton = MKButton()
    var subCategoryID:Int = Int()
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    // Initialise the PFQueryTable tableview
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configure the PFQueryTableView
        self.parseClassName = "SubCategory"
        self.textKey = "SubCategoryName"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }

    override func viewDidAppear(animated: Bool) {
        addLeftNavItemOnView()
        // Config Tableview
        tableView.separatorColor = UIColor.MKColor.Green
        // Add blur effect to background image
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            var bgImage = UIImageView(image: UIImage(named: "Cappuccino.jpg"))
            blurEffectView.frame = bgImage.frame
            bgImage.addSubview(blurEffectView)
            tableView.backgroundView = bgImage
            self.tableView.backgroundView!.layer.zPosition -= 1;
            
            //if you want translucent vibrant table view separator lines
            //tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        }
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "SubCategory")
        query.orderByAscending("SubCategoryName").whereKey("InActive", equalTo: 1)
        return query
    }
    
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
        backButton.addTarget(self, action: "backClick:", forControlEvents: UIControlEvents.TouchUpInside)
    
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        self.navigationItem.title = ""
    }
    
    func backClick(sender: UIButton!) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! MenuCustomCell!
        if cell == nil {
            cell = MenuCustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MenuCell")
        }
        
        // Config cell
        //cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // Extract values from the PFObject to display in the table cell
        if let categoryName = object["SubCategoryName"] as? String {
            cell.customCategoryName.text = categoryName
            cell.customCategoryName.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.customCategoryName.numberOfLines = 0
        }
        
        // Display flag image
        var initialThumbnail = UIImage(named: "DefaultDrink")
        cell.customImage.image = initialThumbnail
        
        var categoryName = object["SubCategoryName"] as? String
        cell.customImage.image = UIImage(named: categoryName!)
        
        if let thumbnail = object["SubCategoryImage"] as? PFFile {
            cell.customImage.file = thumbnail
            cell.customImage.loadInBackground()
            cell.customImage.contentMode = UIViewContentMode.ScaleAspectFit
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        var subCategoryObjects = self.objectAtIndexPath(indexPath)
        subCategoryID = subCategoryObjects?.objectForKey("SubCategoryID") as! Int
        self.performSegueWithIdentifier("MenuDetailSegue", sender: subCategoryID)
        //println(subCategoryID)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MenuDetailSegue"){
            var detailMenuView:MenuDetailViewController = segue.destinationViewController as! MenuDetailViewController
            detailMenuView.subCategoryID = sender as! Int
        }
    }
    
}
