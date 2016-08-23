//
//  StoresTableViewCell.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/16/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class StoresTableViewCell: UITableViewCell {

    @IBOutlet weak var lbStoreName: UILabel! = UILabel()
    @IBOutlet weak var lbStoreAddress: UILabel! = UILabel()
    @IBOutlet weak var lbStoreClose: UILabel! = UILabel()
    @IBOutlet weak var lbDistance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
