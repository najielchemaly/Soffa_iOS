//
//  PaymentHistoryTableViewCell.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class PaymentHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
