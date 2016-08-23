//
//  HotDrinkViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/4/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class HotDrinkViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: Variables
    @IBOutlet weak var drinkCollectionView: UICollectionView!
    var drinksFileArray: NSArray = NSArray()
    var refreshControl: UIRefreshControl!
    let nodeConstructionQueue = NSOperationQueue()
    var hotPickLabel: UILabel = UILabel()
    
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
        //Add Label
        self.hotPickLabel.frame = CGRect(x: dvWidth/2-35, y: 0, width: 70, height: 20)
        self.hotPickLabel.text = "Hot Pick"
        self.hotPickLabel.textAlignment = NSTextAlignment.Center
        self.hotPickLabel.backgroundColor = UIColor(hex: 664337, alpha: 0.2)
        self.hotPickLabel.font = UIFont(name: "Helvetica-Light-Bold", size: 40)
        self.hotPickLabel.textColor = UIColor.whiteColor()
        self.drinkCollectionView?.addSubview(hotPickLabel)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)

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
        query.orderByAscending("ProductID").whereKey("HotPick", equalTo: true)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) hot drinks.")
                self.drinksFileArray = objects!
                //println(self.drinksFileArray)
            }
            self.drinkCollectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DrinkCell", forIndexPath: indexPath) as! HotDrinkCollectionViewCell
        
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
