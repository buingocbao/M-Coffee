//
//  PageItemController.swift
//  Paging_Swift
//
//  Created by Olga Dalton on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
    
    @IBOutlet weak var imageLabel: UILabel!
    // MARK: - Variables
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName+".jpg")
            }
            
        }
    }
    
    @IBOutlet var contentImageView: UIImageView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName+".jpg")
        imageLabel.font = UIFont(name: "Helvetica-Light", size: 15)
        imageLabel.textColor = UIColor.whiteColor()
        imageLabel.backgroundColor = UIColor.blackColor()
        imageLabel.text = imageName
        self.view.bringSubviewToFront(imageLabel)
    }
}
