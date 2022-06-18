//
//  ForgotPasswordViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/19/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonResetPassword: UIButton!
    @IBOutlet weak var buttonResetTopConstraint: NSLayoutConstraint!
    
    var scrollViewOriginalY: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func buttonResetPasswordTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appBlue)
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().forgotPassword(email: self.textFieldEmail.text!)
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let message = response?.message {
                        DispatchQueue.main.async {
                            self.showAlert(message: message, style: .alert, popVC: true)
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
    
    func initializeViews() {
        self.textFieldEmail.layer.borderColor = Colors.lighText.cgColor
        self.textFieldEmail.layer.borderWidth = 1
        self.textFieldEmail.delegate = self
        
        self.scrollViewOriginalY = self.buttonResetTopConstraint.constant
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        
        if textFieldEmail.text == nil || textFieldEmail.text == "" {
            errorMessage = "Email field cannot be empty"
            return false
        }
        if !isValidEmail(text: textFieldEmail.text!) {
            errorMessage = "Invalid email address"
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.buttonResetTopConstraint.constant = self.scrollViewOriginalY
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if textFieldEmail.isFirstResponder {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                
                self.buttonResetTopConstraint.constant = keyboardRectangle.height-self.buttonResetTopConstraint.constant
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
