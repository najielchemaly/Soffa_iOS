//
//  SettingsViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.DashboardNavigationController)
    }
    
    @IBAction func buttonTermsTapped(_ sender: Any) {
        guard let url = URL(string: DatabaseObjects.TermsAndConditions) else {
            return
        }
        
        self.openURL(url: url)
    }
    
    @IBAction func buttonPrivacyTapped(_ sender: Any) {
        guard let url = URL(string: DatabaseObjects.PrivacyPolicy) else {
            return
        }
        
        self.openURL(url: url)
    }
    
    @IBAction func buttonAboutTapped(_ sender: Any) {
        guard let url = URL(string: DatabaseObjects.AboutUs) else {
            return
        }
        
        self.openURL(url: url)
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
