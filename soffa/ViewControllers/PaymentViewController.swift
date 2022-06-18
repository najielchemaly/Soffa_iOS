//
//  PaymentViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastname: UITextField!
    @IBOutlet weak var textFieldCardType: UITextField!
    @IBOutlet weak var textFieldCardNumber: UITextField!
    @IBOutlet weak var textFieldExpires: UITextField!
    @IBOutlet weak var textFieldCVV: UITextField!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var buttonAddWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var labelEmptyView: UILabel!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
        self.initializeViews()
        self.getPaymentMethodData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAddTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.WebViewController, type: .Present)
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.ProfileNavigationViewController)
    }
    
    func initializeViews() {
        self.labelEmptyView.isHidden = true
        self.viewContent.isHidden = true
        self.buttonEdit.isHidden = true
        
        self.viewContent.isEnabled(enable: false)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func getPaymentMethodData() {
        self.showWaitOverlay(color: Colors.appBlue)
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getPaymentMethod()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonMethods = json["paymentMethods"] as? [NSDictionary] {
                        DatabaseObjects.paymentMethods = [PaymentMethod]()
                        for jsonMethod in jsonMethods {
                            let paymentMethod = PaymentMethod.init(dictionary: jsonMethod)
                            DatabaseObjects.paymentMethods.append(paymentMethod!)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
//                            self.fillPaymentMethodInfo()
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
                
                if DatabaseObjects.paymentMethods.count > 0 {
                    self.labelEmptyView.isHidden = true
                    self.viewContent.isHidden = false
                    self.buttonEdit.isHidden = false
//                    self.buttonAdd.isHidden = true
                } else {
                    self.labelEmptyView.isHidden = false
//                    self.buttonAdd.isHidden = false
                }
            }
        }
    }
    
    func fillPaymentMethodInfo() {
        if let paymentMethod = DatabaseObjects.paymentMethods.first {
            self.textFieldFirstName.text = paymentMethod.firstName
            self.textFieldLastname.text = paymentMethod.lastName
            self.textFieldCardType.text = paymentMethod.cardType
            self.textFieldCardNumber.text = paymentMethod.cardNumber
            self.textFieldExpires.text = paymentMethod.expires
            self.textFieldCVV.text = paymentMethod.cvv
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseObjects.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as? PaymentTableViewCell {
            cell.selectionStyle = .none
            
            let payment = DatabaseObjects.paymentMethods[indexPath.row]
            cell.labelTitle.text = "Payment method " + String(describing: indexPath.row+1)
            cell.textFieldFirstname.text = payment.firstName
            cell.textFieldLastname.text = payment.lastName
            cell.textFieldCardType.text = payment.cardType
            cell.textFieldNumber.text = payment.cardNumber
            cell.textFieldExpires.text = payment.expires
            cell.textFieldCVV.text = payment.cvv
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let alert = UIAlertController(title: "SOFFA", message: "Are you sure you want to delete the payment method?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                let payment = DatabaseObjects.paymentMethods[indexPath.row]
                if let id = payment.id, let cvv = payment.cvv {
                    self.showWaitOverlay(color: Colors.appBlue)
                    DispatchQueue.global(qos: .background).async {
                        let response = Services.init().deletePayment(id: id, cvv: cvv)
                        if response?.status == ResponseStatus.SUCCESS.rawValue {
                            DatabaseObjects.paymentMethods.remove(at: indexPath.row)
                            DispatchQueue.main.async {
                                tableView.deleteRows(at: [indexPath], with: .automatic)
                            }
                        } else {
                            if let message = response?.message {
                                self.showAlert(message: message, style: .alert)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.removeAllOverlays()
                        }
                    }
                }
            }))
        }
    }
    
    func dummyData() {
        for i in 0 ..< 10 {
            let payment = PaymentMethod()
            let index = String(describing: i+1)
            payment.id = index
            payment.firstName = "Firstname " + index
            payment.lastName = "Lastname " + index
            payment.cardType = "Type " + index
            payment.cardNumber = "Number " + index
            payment.expires = "Expires " + index
            payment.cvv = "CVV " + index
            
            DatabaseObjects.paymentMethods.append(payment)
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
