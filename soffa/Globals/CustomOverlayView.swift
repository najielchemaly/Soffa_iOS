//
//  CustomOverlayView.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/21/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

protocol CustomOverlayDelegate{
    func didCancel(overlayView:CustomOverlayView)
    func didShoot(overlayView:CustomOverlayView)
}

class CustomOverlayView: UIView {
    
    @IBOutlet weak var buttonLibrary: UIButton!
    
    var delegate:CustomOverlayDelegate! = nil
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        delegate.didCancel(overlayView: self)
    }
    
    @IBAction func takeButtonTapped(sender: UIButton) {
        delegate.didShoot(overlayView: self)
    }
}
