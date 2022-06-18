//
//  LoginViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/19/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonContinueWithFacebook: UIButton!
    @IBOutlet weak var buttonSignup: UIButton!
    
    var loginButton: FBSDKLoginButton!
    var loginManager: FBSDKLoginManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupDelegates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonForgotPasswordTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.ForgotPasswordViewController, type: .Push)
    }
    
    @IBAction func buttonLoginTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appBlue)
            let email = self.textFieldEmail.text!
            let password = self.textFieldPassword.text!
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().login(email: email, password: password)
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonUser = json["user"] as? NSDictionary {
                            DatabaseObjects.user = User.init(dictionary: jsonUser)!
                            
                            self.saveUserInUserDefaults()
                            
                            DispatchQueue.main.async {
                                self.redirectToVC(storyboardId: StoryboardIds.IntroViewController, type: .Push)
                            }
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
    
    @IBAction func continueWithFacebook(_ sender: Any) {
        self.showWaitOverlay(color: Colors.appBlue)
        
        if (FBSDKAccessToken.current()) != nil
//            , currentAccessToken.appID != FBSDKSettings.appID()
        {
            loginManager.logOut()
        }
        
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { result, error in
            if error != nil {
                print(error!)
            } else if (result?.isCancelled)! {
                DispatchQueue.main.async {
                    self.removeAllOverlays()
                }
            } else if result?.grantedPermissions != nil {
                DatabaseObjects.user = User()
                DatabaseObjects.user.facebookToken = result?.token.tokenString
                
                self.getFacebookParameters()
            }
        })
    }

    @IBAction func buttonSignupTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.SignupViewController, type: .Push)
    }
    
    func getFacebookParameters(){
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, gender, location, picture, birthday"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if (error == nil)
            {
                if let dict = result as? NSDictionary {
                    if let gender = (dict.object(forKey: "gender") as? String) {
                        DatabaseObjects.user.gender = gender
                    }
                    if let id = (dict.object(forKey: "id") as? String) {
                        DatabaseObjects.user.facebookID = id
                    }
                    if let name = (dict.object(forKey: "name") as? String) {
                        DatabaseObjects.user.firstName = name
                    }
                    if let email = (dict.object(forKey: "email") as? String) {
                        DatabaseObjects.user.email = email
                    }
//                    if let picture = (dict.object(forKey: "picture") as? NSDictionary) {
//                        if let data = picture.object(forKey: "data") as? NSDictionary {
//                            if let url = data.object(forKey: "url") as? String {
//
//                            }
//                        }
//                    }
                    DispatchQueue.global(qos: .background).async {
                        let response = Services.init().facebookLogin(user: DatabaseObjects.user)
                        if response?.status == ResponseStatus.SUCCESS.rawValue {
                            if let json = response?.json?.first {
                                if let jsonUser = json["user"] as? NSDictionary {
                                    DatabaseObjects.user = User.init(dictionary: jsonUser)!
                                    
                                    self.saveUserInUserDefaults()
                                    
                                    DispatchQueue.main.async {
                                        self.redirectToVC(storyboardId: StoryboardIds.IntroViewController, type: .Push)
                                    }
                                }
                            }
                        } else if response?.status == ResponseStatus.FACEBOOK_UNAUTHORIZED.rawValue {
                            DispatchQueue.main.async {
                                topViewControllerName = StoryboardIds.EditMyProfileNavigationController
                                self.redirectToVC(storyboardId: StoryboardIds.SideMenuNavigationController, type: .Present)
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
                    DispatchQueue.main.async {
                        self.removeAllOverlays()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.removeAllOverlays()
                }
            }
        })
    }
    
    func initializeViews() {
        self.textFieldEmail.layer.borderColor = Colors.lighText.cgColor
        self.textFieldEmail.layer.borderWidth = 1        
        self.textFieldPassword.layer.borderColor = Colors.lighText.cgColor
        self.textFieldPassword.layer.borderWidth = 1
        
        self.loginButton = FBSDKLoginButton()
        self.loginButton.readPermissions = ["public_profile", "email"]
        
        self.loginManager = FBSDKLoginManager()
    }
    
    func setupDelegates() {
        self.textFieldEmail.delegate = self
        self.textFieldPassword.delegate = self
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
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    func fillDummyData() {
        let user = User()
        user.firstName = "Naji"
        user.lastName = "Chemaly"
        user.age = "27"
        user.gender = "male"
        user.nationality = "Lebanon"
        user.phoneNumber = "+96171169428"
        user.email = "najielchemaly@gmail.com"
        DatabaseObjects.user = user
        
        self.saveUserInUserDefaults()
        
        DispatchQueue.main.async {
            self.redirectToVC(storyboardId: StoryboardIds.IntroViewController, type: .Push)
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
