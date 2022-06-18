//
//  PaymentHistoryViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class PaymentHistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelEmptyView: UILabel!
    
    var filteredPaymentHistories: [PaymentHistory] = [PaymentHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
        self.getPaymentHistoryData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.ProfileNavigationViewController)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "PaymentHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentHistoryTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.labelEmptyView.isHidden = true
    }
    
    func getPaymentHistoryData() {
        self.showWaitOverlay(color: Colors.appBlue)
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getPaymentHistory()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonHistories = json["history"] as? [NSDictionary] {
                        DatabaseObjects.paymentHistories = [PaymentHistory]()
                        for jsonHistory in jsonHistories {
                            let paymentHistory = PaymentHistory.init(dictionary: jsonHistory)
                            DatabaseObjects.paymentHistories.append(paymentHistory!)
                        }
                        
                        self.filteredPaymentHistories = DatabaseObjects.paymentHistories
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
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
                
                if DatabaseObjects.paymentHistories.count == 0 {
                    self.labelEmptyView.isHidden = false
                } else {
                    self.labelEmptyView.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPaymentHistories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryTableViewCell") as? PaymentHistoryTableViewCell {
            
            let paymentHistory = filteredPaymentHistories[indexPath.row]
            cell.labelLocation.text = paymentHistory.accessLocation
            cell.labelDate.text = paymentHistory.accessDate
            cell.labelTime.text = paymentHistory.accessTime
            cell.labelAmount.text = paymentHistory.amountPaid
            
            return cell
        }
        
        return UITableViewCell()
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
