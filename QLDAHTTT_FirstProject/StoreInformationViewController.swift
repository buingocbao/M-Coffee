//
//  StoreInformationViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/17/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class StoreInformationViewController: UIViewController {

    @IBOutlet weak var btExit: MKButton!
    @IBOutlet weak var lbStoreName: UILabel!
    @IBOutlet weak var lbStoreAddress: UILabel!
    @IBOutlet weak var lbHour: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    var storeFileArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Exit Button
        btExit.cornerRadius = 30.0
        btExit.backgroundLayerCornerRadius = 30.0
        btExit.maskEnabled = false
        btExit.circleGrowRatioMax = 1.75
        btExit.rippleLocation = .Center
        btExit.aniDuration = 0.85
        self.view.bringSubviewToFront(btExit)
        
        btExit.layer.shadowOpacity = 0.75
        btExit.layer.shadowRadius = 3.5
        btExit.layer.shadowColor = UIColor.blackColor().CGColor
        btExit.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        // Config label
        //Set label text
        var storeObject:PFObject = storeFileArray.objectAtIndex(0) as! PFObject
        if let storeName = storeObject["StoreName"] as? String {
            lbStoreName.text = "M-Coffee \n\(storeName)"
        }
        
        if let storeAddress = storeObject["StoreAddress"] as? String {
            lbStoreAddress.text = storeAddress
        }
        
        if let storeOpenHour = storeObject["StoreOpenHour"] as? String {
            if let storeCloseHour = storeObject["StoreCloseHour"] as? String {
                lbHour.text = "Store opens from \(storeOpenHour):00 to \(storeCloseHour):00"
            }
        }
        
        if let storeDes = storeObject["StoreDescription"] as? String {
            lbDescription.text = storeDes
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btExitClick(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
}
