//
//  ProfileViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var buttonMyPlate: UIButton!
    @IBOutlet weak var buttonMyVehicles: UIButton!
    @IBOutlet weak var buttonPaymentHistory: UIButton!
    @IBOutlet weak var buttonPaymentMethod: UIButton!
    @IBOutlet weak var buttonParking: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let vehicle = DatabaseObjects.myVehicles.last {
            if let plateNumber = vehicle.plateNumber {
                self.buttonMyPlate.setTitle(plateNumber, for: .normal)
                self.buttonMyPlate.isEnabled(enable: true)
            } else {
                self.buttonMyPlate.isEnabled(enable: false)
            }
        } else {
            self.buttonMyPlate.isEnabled(enable: false)
        }
        
//        self.initializeViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fillUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.buttonMyVehicles.imageView?.contentMode = .scaleAspectFit
        self.buttonMyPlate.imageView?.contentMode = .scaleAspectFit
        self.buttonPaymentMethod.imageView?.contentMode = .scaleAspectFit
        self.buttonParking.imageView?.contentMode = .scaleAspectFit
        
        self.buttonMyVehicles.imageView?.clipsToBounds = true
        self.buttonMyPlate.imageView?.clipsToBounds = true
        self.buttonPaymentMethod.imageView?.clipsToBounds = true
        self.buttonParking.imageView?.clipsToBounds = true
    }
    
    @IBAction func buttonEditProfileTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.EditMyProfileNavigationController)
    }
    
    @IBAction func buttonMyPlateTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.MyVehiclesNavigationController)
    }
    
    @IBAction func buttonMyVehiclesTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.MyVehiclesNavigationController)
    }
    
    @IBAction func buttonPaymentHistoryTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.PaymentHistoryNavigationController)
    }
    
    @IBAction func buttonPaymentMethodTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.PaymentMethodNavigationController)
    }

    @IBAction func buttonParkingsTapped(_ sender: Any) {
        parkingComingFrom = ParkingComingFrom.Dashboard.identifier
        self.redirectToVC(storyboardId: StoryboardIds.ParkingsViewController, type: .Push)
    }
    
    @IBAction func buttonSignoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "SOFFA", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            self.showWaitOverlay(color: Colors.appBlue)
            
            DispatchQueue.global(qos: .background).async {
                _ = Services.init().logout()
                
                DispatchQueue.main.async {
                    self.removeAllOverlays()
                    self.logout()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fillUserInfo() {
        if let firstName = DatabaseObjects.user.firstName, let lastName = DatabaseObjects.user.lastName {
            self.labelFullName.text = firstName + " " + lastName
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
