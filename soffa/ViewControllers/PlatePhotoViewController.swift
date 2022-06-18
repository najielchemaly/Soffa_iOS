//
//  PlatePhotoViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/21/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class PlatePhotoViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomOverlayDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var buttonRetakePicture: UIButton!
    @IBOutlet weak var textFieldValidationCode: UITextField!
    @IBOutlet weak var buttonValidate: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    var picker: UIImagePickerController!
    var libraryPicker: UIImagePickerController!
    var selectedImage: UIImage!
    
    var textFieldBottomPadding: CGFloat = 10
    var textFieldOriginalY: CGFloat = 0
    
    var viewDidAppear: Bool = false
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        if takePhotoComingFrom != nil {
            if takePhotoComingFrom == TakePhotoComingFrom.Signup.identifier {
                self.buttonBack.isHidden = true
            } else if takePhotoComingFrom == TakePhotoComingFrom.Dashboard.identifier {
                self.buttonBack.isHidden = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.imageHeightConstraint.constant = self.textFieldOriginalY
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textFieldOriginalY = self.imageHeightConstraint.constant
        
        if !viewDidAppear {
            self.openCustomCamera()
        } else if selectedImage != nil {
            self.showWaitOverlay(color: Colors.appBlue)
            DispatchQueue.global(qos: .background).async {
                // TODO fix the aspect ratio
                self.selectedImage = self.selectedImage.imageRotatedByDegrees(deg: 90)
                let response = Services.init().sendLPRImage2(imageFile: self.selectedImage)
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let plateNumber = json["plateNumber"] as? String {
                            DispatchQueue.main.async {
                                DatabaseObjects.plateNumber = plateNumber
                                self.textFieldValidationCode.text = plateNumber
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
        }
        
        viewDidAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonRetakePictureTapped(_ sender: Any) {
        self.openCustomCamera()
    }
    
    @IBAction func buttonValidateTapped(_ sender: Any) {
        if textFieldValidationCode.text != nil && textFieldValidationCode.text != "" {
            if textFieldValidationCode.text == DatabaseObjects.plateNumber {
                let alert = UIAlertController(title: "SOFFA", message: "Are you sure you want to validate this plate number? \n" + self.textFieldValidationCode.text!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Validate", style: .default, handler: { action in
                    self.showWaitOverlay(color: Colors.appBlue)
                    let plateNumber = self.textFieldValidationCode.text!
                    DispatchQueue.global(qos: .background).async {
                        let response = Services.init().addVehicle(plateNumber: plateNumber)
                        if response?.status == ResponseStatus.SUCCESS.rawValue {
                            DispatchQueue.main.async {
                                if takePhotoComingFrom == TakePhotoComingFrom.Signup.identifier {
                                    parkingComingFrom = ParkingComingFrom.Signup.identifier
                                    self.redirectToVC(storyboardId: StoryboardIds.ParkingsViewController, type: .Push)
                                } else {
                                    self.popVC()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showPopupView(name: "PlateErrorPopupView")
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.removeAllOverlays()
                        }
                    }
                }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                self.showAlert(message: "Invalid Plate Number, please retake a photo", style: .alert)
            }
        }
    }
    
    func initializeViews() {
        self.textFieldValidationCode.layer.borderColor = Colors.lighText.cgColor
        self.textFieldValidationCode.layer.borderWidth = 1
        
        self.textFieldValidationCode.backgroundColor = .white
        
        self.textFieldValidationCode.delegate = self
    }
    
    func openCustomCamera() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            self.selectedImage = nil
            self.textFieldValidationCode.text = nil
            
            picker = CustomImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.showsCameraControls = false
            picker.delegate = self
            
            let customViewController = CustomOverlayViewController(
                nibName:"CustomOverlayViewController",
                bundle: nil
            )
            
            if let customView:CustomOverlayView = customViewController.view as? CustomOverlayView {
                customView.buttonLibrary.addTarget(self, action: #selector(buttonLibraryTapped), for: .touchUpInside)
                
                customView.frame = self.picker.view.frame
                customView.delegate = self
                
                picker.modalPresentationStyle = .fullScreen
                present(picker, animated: true, completion: {
                    self.picker.cameraOverlayView = customView
                })
            }
        } else {
            self.showAlert(message: "This device does not support camera", style: .alert)
        }
    }
    
    //MARK: Image Picker Controller Delegates

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            UIImageWriteToSavedPhotosAlbum(selectedImage, self,nil, nil)
            self.selectedImage = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Custom View Delegates
    
    func didCancel(overlayView:CustomOverlayView) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func didShoot(overlayView:CustomOverlayView) {
        picker.takePicture()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.imageHeightConstraint.constant = self.textFieldOriginalY
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            let positionY = self.view.frame.size.height-(keyboardRectangle.height+self.textFieldValidationCode.frame.size.height+self.textFieldBottomPadding)
            let height = self.textFieldValidationCode.frame.origin.y - positionY
            if height > 0 {
                self.imageHeightConstraint.constant -= height
            }
        }
    }
    
    @objc func buttonLibraryTapped() {
        self.selectedImage = nil
        self.textFieldValidationCode.text = nil
        
        if libraryPicker == nil {
            libraryPicker = UIImagePickerController()
            libraryPicker.allowsEditing = true
            libraryPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            libraryPicker.delegate = self
        }
    
        if self.picker != nil {
            self.picker.dismiss(animated: true, completion: {
                self.present(self.libraryPicker, animated: true, completion: nil)
            })
        }
    }
}

class CustomImagePickerController: UIImagePickerController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showPopupView(name: "PlatePhotoPopupView")
    }
    
    var popupView: UIView!
    var shadowView: UIView!
    var contentView: UIView!
    func showPopupView(name: String, message: String = "") {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePopupView))
        tap.cancelsTouchesInView = false
        
        let view = Bundle.main.loadNibNamed(name, owner: self.view, options: nil)
        if let popupView = view?.first as? PlatePhotoPopupView {
            popupView.buttonClose.addTarget(self, action: #selector(hidePopupView), for: .touchUpInside)
            
            popupView.shadowView.addGestureRecognizer(tap)
            
            self.shadowView = popupView.shadowView
            self.contentView = popupView.contentView
            
            popupView.contentView.frame.origin.y = self.view.frame.size.height
            
            popupView.shadowView.alpha = 0
            
            self.popupView = popupView
            self.popupView.tag = 3
            
            UIView.animate(withDuration: 0.3, animations: {
                popupView.contentView.frame.origin.y = 0
                popupView.shadowView.alpha = 1
            })
        }
        
        self.popupView.frame = self.view.bounds
        self.view.addSubview(self.popupView)
        self.view.bringSubview(toFront: self.popupView)
    }
    
    @objc func hidePopupView() {
        if self.popupView != nil && contentView != nil && shadowView != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.center.y = self.view.frame.size.height
                self.shadowView.alpha = 0
            }, completion: { success in
                self.popupView.removeFromSuperview()
                self.popupView = nil
            })
        }
    }
    
}
