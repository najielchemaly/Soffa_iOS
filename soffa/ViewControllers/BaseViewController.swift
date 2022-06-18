//
//  BaseViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/19/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit
import GoogleMaps
import SidebarOverlay
import Kingfisher

class BaseViewController: SOContainerViewController {

    var toolbarView: ToolbarView!    
    
    let genders: [String] = [
        "Male",
        "Female"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isMenuRoot() {
            sideMenuViewController = self
            
            self.menuSide = .left
            self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIds.MenuViewController)
        }
        
        if hasToolbar() {
            self.setupToolBarView()
        }
        
        self.setupHideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentVC = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var isSideViewControllerPresented: Bool {
        didSet {
            _ = isSideViewControllerPresented ? "opened" : "closed"
            _ = self.menuSide == .left ? "left" : "right"
        }
    }
    
    func setupHideKeyboard() {
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func isMenuRoot() -> Bool {
        if self is SideMenuViewController {
            return true
        }
        
        return false
    }
    
    func hasToolbar() -> Bool {
        if self is DashboardViewController || self is LoyaltyPointsViewController || self is ProfileViewController || self is ChangePasswordViewController || self is PaymentViewController || self is ContactUsViewController || self is SettingsViewController || self is MyVehiclesViewController || self is PaymentHistoryViewController || self is EditProfileViewController {
            return true
        }
        
        return false
    }
    
    func setupToolBarView() {
        let view = Bundle.main.loadNibNamed("ToolbarView", owner: self.view, options: nil)
        if let toolbarView = view?.first as? ToolbarView {
            self.toolbarView = toolbarView
            self.toolbarView.frame.size.width = self.view.frame.size.width
            self.toolbarView.frame.origin = CGPoint(x: 0, y: 0)
            self.view.addSubview(self.toolbarView)
        }
    }
    
    var popupView: UIView!
    var shadowView: UIView!
    var contentView: UIView!
    func showPopupView(name: String, message: String = "", row: Int = 0) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePopupView))
        tap.cancelsTouchesInView = false
        
        let view = Bundle.main.loadNibNamed(name, owner: self.view, options: nil)
        if let popupView = view?.first as? CountriesView {
            popupView.setupTableView()
            
            popupView.topView.addGestureRecognizer(tap)
            
            self.shadowView = popupView.shadowView
            self.contentView = popupView.contentView
            
            self.contentView.frame.origin.y = self.view.frame.size.height
            
            self.shadowView.alpha = 0
            
            self.popupView = popupView
            self.popupView.tag = 1
            
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.frame.origin.y = 0
                self.shadowView.alpha = 1
            })
        } else if let popupView = view?.first as? SignupPopupView {
            popupView.buttonClose.addTarget(self, action: #selector(hidePopupView), for: .touchUpInside)
            
            let range = NSRange(location: 0, length: 5)
            let attributedMessage = NSMutableAttributedString(string: "Oops!\n" + message)
            attributedMessage.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(hexString: "#2398D5") ?? UIColor.darkGray, range: range)
            
            popupView.labelTitle.attributedText = attributedMessage
            
            popupView.shadowView.addGestureRecognizer(tap)
            
            self.shadowView = popupView.shadowView
            self.contentView = popupView.contentView
            
            self.contentView.frame.origin.y = self.view.frame.size.height
            
            self.shadowView.alpha = 0
            
            self.popupView = popupView
            self.popupView.tag = 2
            
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.frame.origin.y = 0
                self.shadowView.alpha = 1
            })
        } else if let popupView = view?.first as? PlatePhotoPopupView {
            popupView.buttonClose.addTarget(self, action: #selector(hidePopupView), for: .touchUpInside)
            
            popupView.shadowView.addGestureRecognizer(tap)
            
            self.shadowView = popupView.shadowView
            self.contentView = popupView.contentView
            
            self.contentView.frame.origin.y = self.view.frame.size.height
            
            self.shadowView.alpha = 0
            
            self.popupView = popupView
            self.popupView.tag = 3
            
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.frame.origin.y = 0
                self.shadowView.alpha = 1
            })
        } else if let popupView = view?.first as? PlateErrorPopupView {
            popupView.buttonClose.addTarget(self, action: #selector(hidePopupView), for: .touchUpInside)
            
            popupView.shadowView.addGestureRecognizer(tap)
            
            self.shadowView = popupView.shadowView
            self.contentView = popupView.contentView
            
            self.contentView.frame.origin.y = self.view.frame.size.height
            
            self.shadowView.alpha = 0
            
            self.popupView = popupView
            self.popupView.tag = 3
            
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.frame.origin.y = 0
                self.shadowView.alpha = 1
            })
        } else if let popupView = view?.first as? MapPinView {
            let parking = DatabaseObjects.parkings[row]
            
            popupView.labelTitle.text = parking.title
            popupView.labelDescription.text = parking.description?.replacingOccurrences(of: "\\n", with: "\n")
            popupView.labelAccessHours.text = parking.accessHours
            
            if let location = parking.location {
                let coordinates = location.split{$0 == ","}.map(String.init)
                if let latitude = coordinates.first, let longitude = coordinates.last {
                    let location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                    if DatabaseObjects.userLocation != nil {
                        let distanceInMeters: CLLocationDistance = DatabaseObjects.userLocation.distance(from: location)
                        let distanceInKilometers = round(1000*(distanceInMeters/1000))/1000
                        popupView.labelDistance.text = String(describing: distanceInKilometers) + " km"
                    }
                }
            }
            
            if let imageUrl = parking.imgUrl {
                popupView.imageView.kf.setImage(with: URL(string: imageUrl))
            }
            
            popupView.buttonGetDirections.tag = row
            popupView.buttonGetDirections.addTarget(self, action: #selector(buttonGetDirectionsTapped(sender:)), for: .touchUpInside)
            
//            popupView.buttonBookNow.tag = row
//            popupView.buttonBookNow.addTarget(self, action: #selector(buttonBookNowTapped(sender:)), for: .touchUpInside)
            
            popupView.buttonClose.addTarget(self, action: #selector(self.hidePopupView), for: .touchUpInside)
            
//            popupView.shadowView.addGestureRecognizer(tap)
//
//            self.shadowView = popupView.shadowView
//            self.contentView = popupView.contentView
            
//            self.contentView.frame.origin.y = self.view.frame.size.height
//            
//            self.shadowView.alpha = 0
            
            self.popupView = popupView
            self.popupView.tag = 3
            
            UIView.animate(withDuration: 0.3, animations: {
//                self.contentView.frame.origin.y = 0
//                self.shadowView.alpha = 1
            })
        }
        
        self.popupView.frame = self.view.bounds
        self.view.addSubview(self.popupView)
        self.view.bringSubview(toFront: self.popupView)
    }
    
    @objc func hidePopupView() {
        if self.popupView != nil && contentView != nil && shadowView != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.center.y = self.view.frame.size.height
                self.shadowView.alpha = 0
            }, completion: { success in
                self.popupView.removeFromSuperview()
                self.popupView = nil
            })
        } else if self.popupView != nil {
            self.popupView.removeFromSuperview()
            self.popupView = nil
        }
    }
    
    func saveUserInUserDefaults() {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: DatabaseObjects.user)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: "user")
        userDefaults.synchronize()
    }
    
    func openURL(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func buttonGetDirectionsTapped(sender: UIButton) {
        let parking = DatabaseObjects.parkings[sender.tag]
        if let location = parking.location {
            let coordinates = location.split{$0 == ","}.map(String.init)
            if let latitude = coordinates.first, let longitude = coordinates.last {
                if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps:")!) {
                    let urlString = "comgooglemaps://?ll=\(latitude),\(longitude)"
                    UIApplication.shared.openURL(URL(string: urlString)!)
                }
                else {
                    let string = "http://maps.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)"
                    UIApplication.shared.openURL(URL(string: string)!)
                }
            }
        }
    }
    
    @objc func buttonBookNowTapped(sender: UIButton) {
        let parking = DatabaseObjects.parkings[sender.tag]
        if let phoneNumber = parking.phoneNumber {
            let alert = UIAlertController(title: parking.title, message: "Are you sure you want to call \n" + phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines) + " ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { action in
                if let url = URL(string: "tel://\(phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines))"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    
                    self.hidePopupView()
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func hideMenuController() {
        if let parentVC = currentVC.parent?.parent {
            if let container = parentVC.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
        }
    }
    
    func setTopViewController(viewControllerName: String) {
        topViewControllerName = viewControllerName
        sideMenuViewController.topViewController = self.storyboard?.instantiateViewController(withIdentifier: topViewControllerName)
    }
    
    func logout() {
        DispatchQueue.main.async {
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "user")
            userDefaults.synchronize()
            
            self.removeAllOverlays()
            
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIds.LoginNavigationController) as? UINavigationController {
                appDelegate.window?.rootViewController = loginVC
            }
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
