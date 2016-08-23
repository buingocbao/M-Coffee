//
//  MenuDetailViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/8/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class MenuDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {

    // MARK: Variables
    @IBOutlet weak var drinkCollectionView: UICollectionView!
    var drinksFileArray: NSArray = NSArray()
    var refreshControl: UIRefreshControl!
    let nodeConstructionQueue = NSOperationQueue()
    var subCategoryID: Int = Int()
    var backButton:MKButton = MKButton()
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        transparentNavigationBar()
        // Add blur effect to background image
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            var bgImage = UIImageView(image: UIImage(named: "Cappuccino.jpg"))
            blurEffectView.frame = bgImage.frame
            bgImage.addSubview(blurEffectView)
            bgImage.frame = self.view.bounds
            self.view.addSubview(bgImage)
            self.view.sendSubviewToBack(bgImage)
            self.view.bringSubviewToFront(drinkCollectionView)
            //self.drinkCollectionView.backgroundView!.layer.zPosition -= 1;
            
            //if you want translucent vibrant table view separator lines
            //tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        }
        addLeftNavItemOnView()
        // Do any additional setup after loading the view.
        // Set delegate and DataSource
        drinkCollectionView!.dataSource = self
        drinkCollectionView!.delegate = self
        // Config background
        self.drinkCollectionView.backgroundColor = UIColor.clearColor()
        //configBackground()
        // Config Refresh Control
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("imageRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.drinkCollectionView?.addSubview(refreshControl)
        self.queryParseMethod()
        
    }

    func transparentNavigationBar() {
        // Transparent navigation bar
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clearColor()
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
        self.navigationItem.title = "Menu"
    }
    
    func backClick(sender: UIButton!) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Query Parse Method
    // Define the query that will provide the data for the table view
    func queryParseMethod() {
        println("Start query")
        var query = PFQuery(className: "Product")
        query.orderByAscending("ProductID").whereKey("SubCategoryID", equalTo: subCategoryID)
        if query.countObjects() != 0 {
            query.findObjectsInBackgroundWithBlock {
                (objects, error) -> Void in
                if error == nil {
                    // The find succeeded.
                    println("Successfully retrieved \(objects!.count) drinks.")
                    self.drinksFileArray = objects!
                    //println(self.drinksFileArray)
                }
                self.drinkCollectionView.reloadData()
            }
        } else {
            var alert = UIAlertController(title: "Sorry", message: "There's no drink to show in this menu", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Back to Menu", style: UIAlertActionStyle.Default, handler: { action in
                
                switch action.style{
                case .Default:
                    println("default")
                    self.navigationController?.popViewControllerAnimated(true)
                case .Cancel:
                    println("cancel")
                    
                case .Destructive:
                    println("destructive")
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // imageRefresh function
    func imageRefresh() {
        queryParseMethod()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: Setting Colleciton View
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.drinksFileArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuCell", forIndexPath: indexPath) as! MenuDetailCollectionViewCell
        
        // Configure the cell
        var drinkObject:PFObject = drinksFileArray.objectAtIndex(indexPath.row) as! PFObject
        var imageFile:PFFile = drinkObject["ProductImage"] as! PFFile
        // Set init image if drink image in cell doesn't load.
        var initImage = UIImage(named: "DefaultDrink")
        //cell.drinkImageView.image = initImage
        cell.featureImageSizeOptional = initImage?.size
        //cell.titleLabel.attributedText = NSAttributedString.attributedStringForTitleText("Drink")
        imageFile.getDataInBackgroundWithBlock({(data, error) in
            if error == nil {
                cell.configureCellDisplayWithDrinkInfo(drinkObject, data: data!, nodeConstructionQueue: self.nodeConstructionQueue)
            }
        })
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var drinkObject:PFObject = drinksFileArray.objectAtIndex(indexPath.row) as! PFObject
        self.performSegueWithIdentifier("DetailDrinkViewSegue", sender: drinkObject)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailDrinkViewSegue"){
            var detailDrinkView:HotDetailDrinkViewController = segue.destinationViewController as! HotDetailDrinkViewController
            detailDrinkView.drinkObject = sender as! PFObject
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 202, height: 240)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }


}
