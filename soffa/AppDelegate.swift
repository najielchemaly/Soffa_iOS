//
//  AppDelegate.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/19/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit
import GoogleMaps
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        DispatchQueue.global(qos: .background).async {
//            DispatchQueue.main.async {
//                getCountries()
//            }
//        }
        
        let response = Services.init().getGlobalVariables()
        if response?.status == ResponseStatus.SUCCESS.rawValue {
            if let json = response?.json?.first {
                if let isInReview = json["isInReview"] as? Bool {
                    DatabaseObjects.isInReview = isInReview
                }
                if let jsonUrls = json["urls"] as? NSDictionary {
                    if let privacy = jsonUrls["privacy"] as? String {
                        DatabaseObjects.PrivacyPolicy = privacy
                    }
                    if let terms = jsonUrls["terms"] as? String {
                        DatabaseObjects.TermsAndConditions = terms
                    }
                    if let about = jsonUrls["about"] as? String {
                        DatabaseObjects.AboutUs = about
                    }
                }
            }
        }
        
        GMSServices.provideAPIKey(GMS_APIKEY)
    
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        topViewControllerName = StoryboardIds.DashboardNavigationController
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        if let data = UserDefaults.standard.data(forKey: "user"),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            if let navTabBar = storyboard.instantiateViewController(withIdentifier: StoryboardIds.SideMenuNavigationController) as? UINavigationController {
                DatabaseObjects.user = user
                self.window?.rootViewController = navTabBar
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var sourceApplication: String = ""
        var annotation: String = ""
        if options[.sourceApplication] != nil {
            sourceApplication = options[.sourceApplication] as! String
        }
        if options[.annotation] != nil {
            annotation = options[.annotation] as! String
        }
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

