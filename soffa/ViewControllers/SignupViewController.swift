//
//  SignupViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/20/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class SignupViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldAge: UITextField!
    @IBOutlet weak var textFieldGender: CustomTextField!
    @IBOutlet weak var textFieldCountry: CustomTextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    
    var pickerView: UIPickerView!
    var datePicker: UIDatePicker!
    
    var scrollViewOriginalY: CGFloat = 0
    var selectedCountryCodeLength: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.initializeViews()
        self.setupPickerViews()
        self.setupDelegates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        if isValidData() {
            self.fillTempUserInfo()
            self.redirectToVC(storyboardId: StoryboardIds.RegistrationViewController, type: .Push)
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    func initializeViews() {
        self.textFieldFirstName.layer.borderColor = Colors.lighText.cgColor
        self.textFieldFirstName.layer.borderWidth = 1
        self.textFieldLastName.layer.borderColor = Colors.lighText.cgColor
        self.textFieldLastName.layer.borderWidth = 1
        self.textFieldAge.layer.borderColor = Colors.lighText.cgColor
        self.textFieldAge.layer.borderWidth = 1
        self.textFieldGender.layer.borderColor = Colors.lighText.cgColor
        self.textFieldGender.layer.borderWidth = 1
        self.textFieldCountry.layer.borderColor = Colors.lighText.cgColor
        self.textFieldCountry.layer.borderWidth = 1
        self.textFieldPhoneNumber.layer.borderColor = Colors.lighText.cgColor
        self.textFieldPhoneNumber.layer.borderWidth = 1
        
        self.scrollViewOriginalY = self.scrollViewTopConstraint.constant
        // TODO
//        if isInReview() {
//
//        }
    }
    
    func setupPickerViews() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.textFieldGender.inputView = self.pickerView
        
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
        
        self.textFieldGender.inputAccessoryView = toolbar
        self.textFieldAge.inputAccessoryView = toolbar
    }
    
    func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.textFieldAge.text = dateFormatter.string(from: self.datePicker.date)
    }
    
    func setupDelegates() {
        self.textFieldFirstName.delegate = self
        self.textFieldLastName.delegate = self
        self.textFieldAge.delegate = self
        self.textFieldGender.delegate = self
        self.textFieldCountry.delegate = self
        self.textFieldPhoneNumber.delegate = self
    }
    
    @objc func doneButtonTapped() {
        if textFieldGender.isFirstResponder {
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.textFieldGender.text = self.genders[row]
        } else {
            handleDatePicker()
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
    
    var errorMessage: String!
    func isValidData() -> Bool {
        
        if textFieldFirstName.text == nil || textFieldFirstName.text == "" {
            errorMessage = "First name field cannot be empty"
            return false
        }
        if textFieldLastName.text == nil || textFieldLastName.text == "" {
            errorMessage = "Last name field cannot be empty"
            return false
        }
        if textFieldAge.text == nil || textFieldAge.text == "" {
            errorMessage = "Age field cannot be empty"
            return false
        }
        if textFieldCountry.text == nil || textFieldCountry.text == "" {
            errorMessage = "Country field cannot be empty"
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textFieldFirstName {
            textFieldLastName.becomeFirstResponder()
        } else if textField == textFieldLastName {
            textFieldAge.becomeFirstResponder()
        } else if textField == textFieldAge {
            textFieldGender.becomeFirstResponder()
        } else if textField == textFieldGender {
            textFieldCountry.becomeFirstResponder()
        } else if textField == textFieldCountry {
            textFieldPhoneNumber.becomeFirstResponder()
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
    
    @IBAction func countryTapped(_ sender: Any) {
        self.showPopupView(name: "CountriesView")
    }
    
    func fillTempUserInfo() {
        let tempUser = User()
        tempUser.firstName = textFieldFirstName.text
        tempUser.lastName = textFieldLastName.text
        tempUser.age = textFieldAge.text
        tempUser.gender = textFieldGender.text
        tempUser.nationality = textFieldCountry.text
        tempUser.phoneNumber = textFieldPhoneNumber.text
        DatabaseObjects.tempUser = tempUser
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollViewTopConstraint.constant = self.scrollViewOriginalY
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if textFieldPhoneNumber.isFirstResponder {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                
                self.scrollViewTopConstraint.constant -= (keyboardRectangle.height/2)+20
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
