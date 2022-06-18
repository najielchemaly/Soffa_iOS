//
//  ChangePasswordViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldOldPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupDelegates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.DashboardNavigationController)
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appBlue)
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().changePassword(oldPassword: self.textFieldOldPassword.text!, newPassword: self.textFieldNewPassword.text!)
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let message = response?.message {
                        DispatchQueue.main.async {
                            let alertMessage = message.isEmpty ? "Password successfully changed" : message
                            self.showAlert(message: alertMessage, style: .alert, topVC: StoryboardIds.DashboardNavigationController)
                        }
                    }
                } else {
                    if let message = response?.message {
                        DispatchQueue.main.async {
                            self.showAlert(message: message, style: .alert)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.removeAllOverlays()
                }
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    func setupDelegates() {
        self.textFieldOldPassword.delegate = self
        self.textFieldNewPassword.delegate = self
        self.textFieldConfirmPassword.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldOldPassword {
            textFieldNewPassword.becomeFirstResponder()
        } else if textField == textFieldNewPassword {
            textFieldConfirmPassword.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldOldPassword.text == nil || textFieldOldPassword.text == "" {
            errorMessage = "Old Password field cannot be empty"
            return false
        }
        if textFieldNewPassword.text == nil || textFieldNewPassword.text == "" {
            errorMessage = "New Password field cannot be empty"
            return false
        }
        if textFieldNewPassword.text != textFieldConfirmPassword.text {
            errorMessage = "Passwords do not match"
            return false
        }
        
        return true
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
