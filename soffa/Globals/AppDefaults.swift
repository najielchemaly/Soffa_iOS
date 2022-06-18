//
//  AppDefaults.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/20/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit
import SidebarOverlay

var sideMenuViewController: SOContainerViewController!
var topViewControllerName: String!
var currentVC: UIViewController!
var isUserLoggedIn: Bool = false
var parkingComingFrom: String!
var takePhotoComingFrom: String!
var paymentComingFrom: String!

let GMS_APIKEY = ""

var appDelegate: AppDelegate {
    get {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        }
        
        return AppDelegate()
    }
}

struct Colors {
    
    static let text: UIColor = UIColor(hexString: "#686868")!
    static let lighText: UIColor = UIColor(hexString: "#919496")!
    static let appBlue: UIColor = UIColor(hexString: "#2398D5")!
    
}

struct Fonts {
    
    static let names: [String?] = UIFont.fontNames(forFamilyName: "")
    
    static var textFont_Light: UIFont {
        get {
            if let fontName = Fonts.names[0] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
    static var textFont_Regular: UIFont {
        get {
            if let fontName = Fonts.names[1] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
    static var textFont_Bold: UIFont {
        get {
            if let fontName = Fonts.names[2] {
                return UIFont.init(name: fontName, size: 16)!
            }
            
            return UIFont.init()
        }
    }
    
}

struct StoryboardIds {
    
    static let InitialViewController: String = "InitialViewController"
    static let LoginViewController: String = "LoginViewController"
    static let NavigationTabBarController: String = "navTabBar"
    static let ForgotPasswordViewController: String = "ForgotPasswordViewController"
    static let IntroPageViewController: String = "IntroPageViewController"
    static let Intro1ViewController: String = "Intro1ViewController"
    static let Intro2ViewController: String = "Intro2ViewController"
    static let Intro3ViewController: String = "Intro3ViewController"
    static let Intro4ViewController: String = "Intro4ViewController"
    static let IntroViewController: String = "IntroViewController"
    static let SignupViewController: String = "SignupViewController"
    static let PhoneVerificationViewController: String = "PhoneVerificationViewController"
    static let PlatePhotoViewController: String = "PlatePhotoViewController"
    static let CustomOverlayViewController: String = "CustomOverlayViewController"
    static let MenuViewController: String = "MenuViewController"
    static let DashboardViewController: String = "DashboardViewController"
    static let RegistrationViewController: String = "RegistrationViewController"
    static let PaymentViewController: String = "PaymentViewController"
    static let ParkingsViewController: String = "ParkingsViewController"
    static let DashboardNavigationController: String = "DashboardNavigationController"
    static let LoyaltyPointsViewController: String = "LoyaltyPointsViewController"
    static let MyVehiclesViewController: String = "MyVehiclesViewController"
    static let EditProfileViewController: String = "EditProfileViewController"
    static let ChangePasswordViewController: String = "ChangePasswordViewController"
    static let PaymentHistoryViewController: String = "PaymentHistoryViewController"
    static let SettingsViewController: String = "SettingsViewController"
    static let ContactUsViewController: String = "ContactUsViewController"
    static let SideMenuViewController: String = "SideMenuViewController"
    static let ProfileViewController: String = "ProfileViewController"
    static let LoyaltyNavigationViewController: String = "LoyaltyNavigationViewController"
    static let ProfileNavigationViewController: String = "ProfileNavigationViewController"
    static let SideMenuNavigationController: String = "SideMenuNavigationController"
    static let LoginNavigationController: String = "LoginNavigationController"
    static let WebViewController: String = "WebViewController"
    static let ChangeMyPasswordNavigationController: String = "ChangeMyPasswordNavigationController"
    static let PaymentMethodNavigationController: String = "PaymentMethodNavigationController"
    static let ContactUsNavigationController: String = "ContactUsNavigationController"
    static let SettingsNavigationController: String = "SettingsNavigationController"
    static let MyVehiclesNavigationController: String = "MyVehiclesNavigationController"
    static let PaymentHistoryNavigationController: String = "PaymentHistoryNavigationController"
    static let EditMyProfileNavigationController: String = "EditMyProfileNavigationController"
    
}

enum Keys: String {
    
    case AccessToken = "TOKEN"
    case Access_Token = "access_token"
    case AppVersion = "APP-VERSION"
    case DeviceId = "ID"
    
}

enum SegueId: String {
    
    case None
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
    
}

func isValidEmail(text: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return email.evaluate(with: text)
}

class CustomTextField: UITextField {
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

protocol JSONable {}
extension JSONable {
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                if let parkingsArray = child.value as? Array<Parking> {
                    var parkings = [NSDictionary]()
                    for parking in parkingsArray {
                        parkings.append(parking.toDict() as NSDictionary)
                    }
                    
                    dict[key] = parkings
                } else {
                    dict[key] = child.value
                }
            }
        }
        return dict
    }
}

enum ParkingComingFrom: String {
    
    case none
    case Signup
    case Dashboard
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
    
}

enum TakePhotoComingFrom: String {
    
    case none
    case Signup
    case Dashboard
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
    
}

enum PaymentComingFrom: String {
    
    case none
    case Signup
    case Dashboard
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
    
}
