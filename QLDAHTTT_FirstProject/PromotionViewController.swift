//
//  PromotionViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/5/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class PromotionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: Variables
    
    @IBOutlet weak var drinkCollectionView: UICollectionView!
    var promotionsFileArray: NSArray = NSArray()
    var refreshControl: UIRefreshControl!
    let nodeConstructionQueue = NSOperationQueue()
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)

    }
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Set delegate and DataSource
        drinkCollectionView!.dataSource = self
        drinkCollectionView!.delegate = self
        // Config Refresh Control
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("imageRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.drinkCollectionView?.addSubview(refreshControl)
        self.queryParseMethod()
        
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        
        //Change status bar color
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        // Transparent navigation bar
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clearColor()
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Query Parse Method
    
    // Define the query that will provide the data for the table view
    func queryParseMethod() {
        println("Start query")
        var query = PFQuery(className: "Promotion")
        query.orderByAscending("PromotionID").whereKey("IsValid", equalTo: 1)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) promotions.")
                self.promotionsFileArray = objects!
                //println(self.promotionsFileArray)
            }
            self.drinkCollectionView.reloadData()
        }
    }

    // imageRefresh function
    func imageRefresh() {
        queryParseMethod()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: Setting Collection View
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.promotionsFileArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PromotionCell", forIndexPath: indexPath) as! PromotionCollectionViewCell
        
        // Configure the cell
        var drinkObject:PFObject = promotionsFileArray.objectAtIndex(indexPath.row) as! PFObject
        var imageFile:PFFile = drinkObject["PromotionImage"] as! PFFile
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
        var promotionObject:PFObject = promotionsFileArray.objectAtIndex(indexPath.row) as! PFObject
        self.performSegueWithIdentifier("DetailPromotionViewSegue", sender: promotionObject)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailPromotionViewSegue"){
            var detailDrinkView:PromotionDetailViewController = segue.destinationViewController as! PromotionDetailViewController
            detailDrinkView.promotionObject = sender as! PFObject
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 202, height: 240)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }



}
