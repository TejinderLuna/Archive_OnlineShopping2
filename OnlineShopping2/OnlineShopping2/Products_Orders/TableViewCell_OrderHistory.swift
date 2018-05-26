//
//  OrderHistoryTableViewCell.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/12/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

class TableViewCell_OrderHistory: UITableViewCell {

    @IBOutlet weak var oidLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var pickUpAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
