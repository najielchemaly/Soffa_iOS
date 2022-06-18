//
//  PlateErrorPopupView.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/21/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class PlateErrorPopupView: UIView {

    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonRetakePicture: UIButton!
    @IBOutlet weak var buttonContactUs: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func retakePictureTapped(_ sender: Any) {
        if let platePhotoVC = currentVC as? PlatePhotoViewController {
            platePhotoVC.hidePopupView()            
            platePhotoVC.openCustomCamera()
        }
    }
    
    @IBAction func contactUsTapped(_ sender: Any) {
        if let platePhotoVC = currentVC as? PlatePhotoViewController {
            let number = "0096171169428"
            let alert = UIAlertController(title: "Contact Us", message: "Are you sure you want to call \n" + number + " ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { action in
                if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    
                    platePhotoVC.hidePopupView()
                }
            }))
        
            platePhotoVC.present(alert, animated: true, completion: nil)
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
