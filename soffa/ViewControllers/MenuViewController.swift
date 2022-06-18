//
//  MenuViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rdghts reserved.
//

import UIKit

class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuItems: [MenuItem] = [
        MenuItem.init(image: #imageLiteral(resourceName: "dashboard"), title: "Dashboard"),
        MenuItem.init(image: #imageLiteral(resourceName: "menu_profile"), title: "My Profile"),
        MenuItem.init(image: #imageLiteral(resourceName: "menu_location"), title: "Parking"),
        MenuItem.init(image: #imageLiteral(resourceName: "menu_add"), title: "Add vehicle"),
        MenuItem.init(image: #imageLiteral(resourceName: "menu_loyalty"), title: "My loyalty points"),
        MenuItem.init(image: #imageLiteral(resourceName: "menu_settings"), title: "Settings"),
        MenuItem.init(image: #imageLiteral(resourceName: "changepassword"), title: "Change my password"),
        MenuItem.init(image: #imageLiteral(resourceName: "menu_contactus"), title: "Contact us")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if sideMenuViewController != nil && topViewControllerName != nil {
            sideMenuViewController.topViewController = self.storyboard?.instantiateViewController(withIdentifier: topViewControllerName)
        }
        
        self.tableView.register(UINib.init(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 0
        }
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as? MenuTableViewCell {
            
            let menuItem = self.menuItems[indexPath.row]
            cell.imageViewIcon.image = menuItem.image
            cell.labelTitle.text = menuItem.title
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.hideMenuController()
        
        switch indexPath.row {
        case 0:
            if !(currentVC is DashboardViewController) {
                self.setTopViewController(viewControllerName: StoryboardIds.DashboardNavigationController)
            }
            
            break
        case 1:
            if !(currentVC is ProfileViewController) {
                self.setTopViewController(viewControllerName: StoryboardIds.ProfileNavigationViewController)
            }
            
            break
        case 2:
            parkingComingFrom = ParkingComingFrom.Dashboard.identifier
            self.redirectToVC(storyboardId: StoryboardIds.ParkingsViewController, type: .Push)
            break
        case 3:
            takePhotoComingFrom = TakePhotoComingFrom.Dashboard.identifier
            self.redirectToVC(storyboardId: StoryboardIds.PlatePhotoViewController, type: .Push)
            break
        case 4:
            if !(currentVC is LoyaltyPointsViewController) {
                self.setTopViewController(viewControllerName: StoryboardIds.LoyaltyNavigationViewController)
            }
            break
        case 5:
            if !(currentVC is SettingsViewController) {
                self.setTopViewController(viewControllerName: StoryboardIds.SettingsNavigationController)
            }
            break
        case 6:
            if !(currentVC is ChangePasswordViewController) {
                self.setTopViewController(viewControllerName: StoryboardIds.ChangeMyPasswordNavigationController)
            }
            break
        case 7:
            if !(currentVC is ContactUsViewController) {
                self.setTopViewController(viewControllerName: StoryboardIds.ContactUsNavigationController)
            }
            break
        default:
            break
        }
    }
    
}

class MenuItem {
    var image: UIImage!
    var title: String!
    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
}
