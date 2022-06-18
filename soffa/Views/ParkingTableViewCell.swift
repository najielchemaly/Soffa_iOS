//
//  ParkingTableViewCell.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/21/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class ParkingTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonCheckbox: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonCheckboxTapped(_ sender: Any) {
        self.buttonCheckbox.isSelected = !self.buttonCheckbox.isSelected
    }
    
}
