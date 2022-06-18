//
//  PaymentTableViewCell.swift
//  soffa
//
//  Created by MR.CHEMALY on 2/15/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textFieldFirstname: UITextField!
    @IBOutlet weak var textFieldLastname: UITextField!
    @IBOutlet weak var textFieldCardType: UITextField!
    @IBOutlet weak var textFieldNumber: UITextField!
    @IBOutlet weak var textFieldExpires: UITextField!
    @IBOutlet weak var textFieldCVV: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
