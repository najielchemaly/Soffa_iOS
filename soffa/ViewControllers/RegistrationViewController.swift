//
//  RegistrationViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class RegistrationViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonCheckbox: UIButton!
    @IBOutlet weak var buttonGetStarted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func buttonCheckboxTapped(_ sender: Any) {
        self.buttonCheckbox.isSelected = !self.buttonCheckbox.isSelected
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
    
    @IBAction func buttonGetStartedTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appBlue)
            let email = self.textFieldEmail.text
            let password = self.textFieldPassword.text
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().registerUser(firstName: DatabaseObjects.tempUser.firstName!, lastName: DatabaseObjects.tempUser.lastName!, age: DatabaseObjects.tempUser.age!, gender: DatabaseObjects.tempUser.gender!, nationality: DatabaseObjects.selectedCountryId, phoneNumber: DatabaseObjects.tempUser.phoneNumber!, email: email!, password: password!)
                
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonUser = json["user"] as? NSDictionary {
                            DatabaseObjects.user = User.init(dictionary: jsonUser)!
                            
                            if let verificationCode = json["verificationCode"] as? String {
                                DatabaseObjects.user.verificationCode = verificationCode
                            }
                            
                            self.saveUserInUserDefaults()
                            
                            DispatchQueue.main.async {
                                self.redirectToVC(storyboardId: StoryboardIds.PhoneVerificationViewController, type: .Push)
                            }
                        }
                    }
                } else {
                    if let message = response?.message {
                        DispatchQueue.main.async {
//                            self.showAlert(message: message, style: .alert)
                            self.showPopupView(name: "SignupPopupView", message: message)
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
    
    func initializeViews() {
        self.textFieldEmail.layer.borderColor = Colors.lighText.cgColor
        self.textFieldEmail.layer.borderWidth = 1
        self.textFieldPassword.layer.borderColor = Colors.lighText.cgColor
        self.textFieldPassword.layer.borderWidth = 1
        self.textFieldConfirmPassword.layer.borderColor = Colors.lighText.cgColor
        self.textFieldConfirmPassword.layer.borderWidth = 1
        
        self.textFieldEmail.delegate = self
        self.textFieldPassword.delegate = self
        self.textFieldConfirmPassword.delegate = self
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        
        if textFieldEmail.text == nil || textFieldEmail.text == "" {
            errorMessage = "Email field cannot be empty"
            return false
        }
        if textFieldPassword.text == nil || textFieldPassword.text == "" {
            errorMessage = "Password field cannot be empty"
            return false
        }
        if textFieldPassword.text != textFieldConfirmPassword.text {
            errorMessage = "Passwords do not match"
            return false
        }
        if !buttonCheckbox.isSelected {
            errorMessage = "You must accept the Terms&Conditions and the Privacy Policy"
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textFieldConfirmPassword.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
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
