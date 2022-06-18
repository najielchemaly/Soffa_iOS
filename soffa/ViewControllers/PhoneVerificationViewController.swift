//
//  PhoneVerificationViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/20/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class PhoneVerificationViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldValidationCode: UITextField!
    @IBOutlet weak var buttonResendSMS: UIButton!
    @IBOutlet weak var buttonVerifySMS: UIButton!
    @IBOutlet weak var validationCodeTopConstraint: NSLayoutConstraint!
    
    var textFieldBottomPadding: CGFloat = 10
    var textFieldOriginalY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.initializeViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.validationCodeTopConstraint.constant = self.textFieldOriginalY
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textFieldOriginalY = self.validationCodeTopConstraint.constant //self.textFieldValidationCode.frame.origin.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func buttonResendSMSTapped(_ sender: Any) {
        self.showWaitOverlay(color: Colors.appBlue)
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().sendSMS(phoneNumber: DatabaseObjects.tempUser.phoneNumber!)
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let verificationCode = json["verificationCode"] as? String {
                        DatabaseObjects.user.verificationCode = verificationCode
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
    }
    
    @IBAction func buttonVerifySMSTapped(_ sender: Any) {
        if isValidData() {
            if DatabaseObjects.user.verificationCode == textFieldValidationCode.text {
                self.showWaitOverlay(color: Colors.appBlue)
                DispatchQueue.global(qos: .background).async {
                    let response = Services.init().verifyUser()
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        DispatchQueue.main.async {
                            let userDefaults = UserDefaults.standard
                            if let editedPhoneNumber = userDefaults.string(forKey: "editedPhoneNumber") {
                                userDefaults.removeObject(forKey: "editedPhoneNumber")
                                userDefaults.synchronize()
                                
                                DatabaseObjects.user.phoneNumber = editedPhoneNumber
                                self.popVC()
                            } else {
                                takePhotoComingFrom = TakePhotoComingFrom.Signup.identifier
                                self.redirectToVC(storyboardId: StoryboardIds.PlatePhotoViewController, type: .Push)
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
                self.showAlert(message: "Invalid validation code", style: .alert)
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    func initializeViews() {
        self.textFieldValidationCode.layer.borderColor = Colors.lighText.cgColor
        self.textFieldValidationCode.layer.borderWidth = 1
        
        self.textFieldValidationCode.backgroundColor = .white
        
        self.textFieldValidationCode.delegate = self
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        
        if textFieldValidationCode.text == nil || textFieldValidationCode.text == "" {
            errorMessage = "Validation code field cannot be empty"
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.validationCodeTopConstraint.constant = self.textFieldOriginalY
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            self.validationCodeTopConstraint.constant = self.view.frame.size.height-(keyboardRectangle.height+self.textFieldValidationCode.frame.size.height+self.textFieldBottomPadding)
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
