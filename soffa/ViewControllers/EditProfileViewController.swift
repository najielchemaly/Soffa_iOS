//
//  EditProfileViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var textFieldFirstname: UITextField!
    @IBOutlet weak var textFieldLastname: UITextField!
    @IBOutlet weak var textFieldAge: UITextField!
    @IBOutlet weak var textFieldMale: UITextField!
    @IBOutlet weak var textFieldRegion: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonVerify: UIButton!
    
    var pickerView: UIPickerView!
    var datePicker: UIDatePicker!
    
    var selectedCountryCodeLength: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupDelegates()
        self.setupPickerView()
        
        if (self.presentingViewController?.childViewControllers.last as? LoginViewController) != nil {
            self.toolbarView.buttonMenu.isHidden = true
            self.textFieldEmail.isUserInteractionEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fillUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonVerifyTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.PhoneVerificationViewController, type: .Push)
    }
    
    @IBAction func countryTapped(_ sender: Any) {
        self.showPopupView(name: "CountriesView")
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        if DatabaseObjects.user.email == nil || DatabaseObjects.user.email == "" {
            self.showAlert(message: "Email field is mandatory", style: .alert)
            return
        }
        if DatabaseObjects.user.phoneNumber == nil || DatabaseObjects.user.phoneNumber == "" {
            self.showAlert(message: "Phone Number field is mandatory", style: .alert)
            return
        }
        
        self.setTopViewController(viewControllerName: StoryboardIds.ProfileNavigationViewController)
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appBlue)
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().editProfile(firstName: self.textFieldFirstname.text!, lastName: self.textFieldLastname.text!, age: self.textFieldAge.text!, gender: self.textFieldMale.text!, nationality: DatabaseObjects.selectedCountryId, phoneNumber: self.textFieldPhoneNumber.text!, email: self.textFieldEmail.text!)
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonUser = json["user"] as? NSDictionary {
                            if let user = User.init(dictionary: jsonUser) {
                                let oldVerificationCode = DatabaseObjects.user.verificationCode
                                if user.verificationCode?.lowercased() != oldVerificationCode?.lowercased() {
                                    DispatchQueue.main.async {
                                        let userDefaults = UserDefaults.standard
                                        userDefaults.set(user.phoneNumber, forKey: "editedPhoneNumber")
                                        userDefaults.set(DatabaseObjects.user.phoneNumber, forKey: "verifiedPhoneNumber")
                                        userDefaults.synchronize()
                                        
                                        self.redirectToVC(storyboardId: StoryboardIds.PhoneVerificationViewController, type: .Push)
                                    }
                                }
                                
                                DatabaseObjects.user = user
                            }
                            
                            self.saveUserInUserDefaults()
                            
                            DispatchQueue.main.async {
                                if let message = response?.message {
                                    let alertMessage = message.isEmpty ? "Profile successfully edited" : message
                                    self.showAlert(message: alertMessage, style: .alert, topVC: StoryboardIds.ProfileNavigationViewController)
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if let message = response?.message {
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
    
    func fillUserInfo() {
        self.textFieldFirstname.text = DatabaseObjects.user.firstName
        self.textFieldLastname.text = DatabaseObjects.user.lastName
        self.textFieldMale.text = DatabaseObjects.user.gender
        self.textFieldEmail.text = DatabaseObjects.user.email
        self.textFieldAge.text = DatabaseObjects.user.age
        
        if let nationality = DatabaseObjects.user.nationality {
            DatabaseObjects.selectedCountryId = Int(nationality)!
            let countries = DatabaseObjects.countries.filter { $0.ID == Int(nationality) }
            if let country = countries.first {
                self.textFieldRegion.text = country.CountryName
            }
        }
        
        if let editedPhoneNumber = UserDefaults.standard.string(forKey: "editedPhoneNumber") {
            self.textFieldPhoneNumber.text = editedPhoneNumber
            self.textFieldPhoneNumber.isUserInteractionEnabled = false
            self.textFieldPhoneNumber.alpha = 0.5
            self.buttonVerify.isHidden = false
        } else {
            self.textFieldPhoneNumber.text = DatabaseObjects.user.phoneNumber
            self.textFieldPhoneNumber.isUserInteractionEnabled = true
            self.textFieldPhoneNumber.alpha = 1
            self.buttonVerify.isHidden = true
        }
    }
    
    func setupDelegates() {
        self.textFieldFirstname.delegate = self
        self.textFieldLastname.delegate = self
        self.textFieldAge.delegate = self
        self.textFieldMale.delegate = self
        self.textFieldRegion.delegate = self
        self.textFieldPhoneNumber.delegate = self
        self.textFieldEmail.delegate = self
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.textFieldMale.inputView = self.pickerView
        
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
        self.textFieldAge.inputView = self.datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldMale.inputAccessoryView = toolbar
        self.textFieldAge.inputAccessoryView = toolbar
    }
    
    func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.textFieldAge.text = dateFormatter.string(from: self.datePicker.date)
    }
    
    @objc func doneButtonTapped() {
        if textFieldMale.isFirstResponder {
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.textFieldMale.text = self.genders[row]
        } else {
            self.handleDatePicker()
        }
        
        self.dismissKeyboard()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genders[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldFirstname {
            textFieldLastname.becomeFirstResponder()
        } else if textField == textFieldLastname {
            textFieldAge.becomeFirstResponder()
        } else if textField == textFieldAge {
            textFieldMale.becomeFirstResponder()
        } else if textField == textFieldMale {
            textFieldRegion.becomeFirstResponder()
        } else if textField == textFieldRegion {
            textFieldPhoneNumber.becomeFirstResponder()
        } else if textField == textFieldPhoneNumber {
            textFieldEmail.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textFieldPhoneNumber {
            if let text = textField.text {
                if string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                    text.count == selectedCountryCodeLength {
                    return false
                }
            }
        }
        
        return true
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldFirstname.text == nil || textFieldFirstname.text == "" {
            errorMessage = "First name field cannot be empty."
            return false
        }
        if textFieldLastname.text == nil || textFieldLastname.text == "" {
            errorMessage = "Last name field cannot be empty."
            return false
        }
        if (textFieldEmail.text != nil && textFieldEmail.text != "") && !isValidEmail(text: self.textFieldEmail.text!) {
            errorMessage = "Please enter a valid email."
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
