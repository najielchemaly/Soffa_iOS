//
//  ToolbarView.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/21/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class ToolbarView: UIView {
    
    @IBOutlet weak var buttonMenu: UIButton!
    
    @IBAction func buttonMenuTapped(_ sender: Any) {
        if let parentVC = currentVC.parent?.parent {
            if let container = parentVC.so_containerViewController {
                container.isSideViewControllerPresented = true
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
