//
//  HotDetailDrinkViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/4/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class HotDetailDrinkViewController: UIViewController {
    
    // MARK: Variables

    var drinkObject:PFObject!
    var drinkImage:UIImageView = UIImageView()
    var drinkDes:UITextView = UITextView()
    var drinkSpec:UITextView = UITextView()
    var titleLabel = UILabel()
    let gradientView = GradientView()
    var isExpanded:Bool!
    @IBOutlet weak var btExit: MKButton!

    override func viewDidDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        
        isExpanded = false
        
        // Do any additional setup after loading the view.
        
        // Set drink label
        titleLabel.frame = CGRect(x: 0, y: dvHeight*2/3-50, width: dvWidth, height: 70)
        titleLabel.frame.inset(dx: 10, dy: 10)
        titleLabel.attributedText = NSAttributedString.attributedStringForTitleText(drinkObject["ProductName"] as! String)
        titleLabel.font = UIFont(name: "Helvetica-Light", size: 30)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.view.addSubview(titleLabel)
        //self.view.bringSubviewToFront(titleLabel)
        
        // Set drink description
        self.drinkDes.text = "No information"
        var desFile:PFFile = drinkObject["ProductDescription"] as! PFFile
        desFile.getDataInBackgroundWithBlock ({(data, error) in
            if error == nil {
                self.drinkDes.frame = CGRect(x: 0, y: dvHeight*2/3, width: dvWidth, height: 100)
                self.drinkDes.text = String(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
                self.drinkDes.font = UIFont(name: "Helvetica-Light", size: 15)
                self.drinkDes.textColor = UIColor.whiteColor()
                self.drinkDes.backgroundColor = UIColor.blackColor()
                self.drinkDes.editable = false
                self.drinkDes.selectable = false
            }
        })
        self.view.addSubview(self.drinkDes)
        self.view.bringSubviewToFront(self.drinkDes)
        
        /*
        // Set drink specification
        self.drinkSpec.text = "No information"
        var specFile:PFFile = drinkObject["Specification"] as! PFFile
        specFile.getDataInBackgroundWithBlock({(data, error) in
            if error == nil {
                self.drinkSpec.frame = CGRect(x: 0, y: dvHeight*2/3 + 50, width: dvWidth, height: dvHeight*1/3 - 60)
                self.drinkSpec.text = String(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
                self.drinkSpec.font = UIFont(name: "Helvetica-Light", size: 15)
                self.drinkSpec.textColor = UIColor.whiteColor()
                self.drinkSpec.backgroundColor = UIColor.blackColor()
                self.drinkSpec.editable = false
                self.drinkSpec.selectable = false
                
            }
        })
        self.view.addSubview(self.drinkSpec)
        self.view.bringSubviewToFront(self.drinkSpec)
        */
        // Set drink image
        var imageFile:PFFile = drinkObject["ProductImage"] as! PFFile
        imageFile.getDataInBackgroundWithBlock({(data, error) in
            if error == nil {
                self.drinkImage.frame = CGRect(x: 0, y: 0, width: dvWidth, height: (dvWidth*363)/305)
                self.drinkImage.image = UIImage(data: data!)
                self.view.addSubview(self.drinkImage)
                self.view.sendSubviewToBack(self.drinkImage)
                self.drinkImage.addSubview(self.gradientView)
                self.gradientView.frame = FrameCalculator.frameForGradient(featureImageFrame: self.drinkImage.frame)
                self.gradientView.setNeedsDisplay()
            }
        })
        
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

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btExit(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
