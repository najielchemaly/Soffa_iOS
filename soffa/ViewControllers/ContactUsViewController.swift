//
//  ContactUsViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPurpose: UITextField!
    @IBOutlet weak var textFieldSubject: UITextField!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageViewOriginalY: CGFloat = 0
    var contentSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.initializeViews()
        self.setupDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.contentSize = self.scrollView.contentSize
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.DashboardNavigationController)
    }
    
    @IBAction func buttonContactTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appBlue)
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().contactUs(name: self.textFieldName.text!, email: self.textFieldEmail.text!, purpose: self.textFieldPurpose.text!, subject: self.textFieldSubject.text!, description: self.textViewDescription.text!)
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let message = response?.message {
                        DispatchQueue.main.async {
                            self.showAlert(message: message, style: .alert, topVC: StoryboardIds.DashboardNavigationController)
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
        self.imageViewOriginalY = self.imageViewTopConstraint.constant
    }
    
    func setupDelegates() {
        self.textFieldName.delegate = self
        self.textFieldEmail.delegate = self
        self.textFieldPurpose.delegate = self
        self.textFieldSubject.delegate = self
        self.textViewDescription.delegate = self
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldName.text == nil || textFieldName.text == "" {
            errorMessage = "Name field cannot be empty"
            return false
        }
        if textFieldEmail.text == nil || textFieldEmail.text == "" {
            errorMessage = "Email field cannot be empty"
            return false
        }
        if !isValidEmail(text: textFieldEmail.text!) {
            errorMessage = "Please enter a valid email"
            return false
        }
        if textFieldPurpose.text == nil || textFieldPurpose.text == "" {
            errorMessage = "Purpose field cannot be empty"
            return false
        }
        if textFieldSubject.text == nil || textFieldSubject.text == "" {
            errorMessage = "Subject field cannot be empty"
            return false
        }
        if textViewDescription.text == nil || textViewDescription.text == "" {
            errorMessage = "Description field cannot be empty"
            return false
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.scrollView.contentSize = self.contentSize
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.contentSize = self.contentSize
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if textViewDescription.isFirstResponder || textFieldSubject.isFirstResponder {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                
                self.scrollView.contentSize = CGSize(width: contentSize.width, height: contentSize.height+keyboardRectangle.height/2)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldName {
            textFieldEmail.becomeFirstResponder()
        } else if textField == textFieldEmail {
            textFieldPurpose.becomeFirstResponder()
        } else if textField == textFieldPurpose {
            textFieldSubject.becomeFirstResponder()
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
