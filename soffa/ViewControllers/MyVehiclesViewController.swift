//
//  MyVehiclesViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class MyVehiclesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelEmptyView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
        self.getMyVehiclesData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackPressed(_ sender: Any) {
        self.setTopViewController(viewControllerName: StoryboardIds.ProfileNavigationViewController)
    }
    
    @IBAction func buttonAddTapped(_ sender: Any) {
        takePhotoComingFrom = TakePhotoComingFrom.Dashboard.identifier
        self.redirectToVC(storyboardId: StoryboardIds.PlatePhotoViewController, type: .Push)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "MyVehicleTableViewCell", bundle: nil), forCellReuseIdentifier: "MyVehicleTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.labelEmptyView.isHidden = true
    }
    
    func getMyVehiclesData() {
        self.showWaitOverlay(color: Colors.appBlue)
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getVehicles()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonVehicles = json["vehicles"] as? [NSDictionary] {
                        DatabaseObjects.myVehicles = [Vehicle]()
                        for jsonVehicle in jsonVehicles {
                            let vehicle = Vehicle.init(dictionary: jsonVehicle)
                            DatabaseObjects.myVehicles.append(vehicle!)
                        }
                        
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
                
                if DatabaseObjects.myVehicles.count == 0 {
                    self.labelEmptyView.isHidden = false
                } else {
                    self.labelEmptyView.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseObjects.myVehicles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyVehicleTableViewCell") as? MyVehicleTableViewCell {
            
            let vehicle = DatabaseObjects.myVehicles[indexPath.row]
            
            cell.selectionStyle = .none
            cell.labelPlateNumber.text = vehicle.plateNumber
            
            cell.buttonDelete.tag = indexPath.row
            cell.buttonDelete.addTarget(self, action: #selector(deleteVehicle(sender:)), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func deleteVehicle(sender: UIButton) {
        let alert = UIAlertController(title: "SOFFA", message: "Are you sure you want to delete the vehicle?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            let vehicle = DatabaseObjects.myVehicles[sender.tag]
            self.showWaitOverlay(color: Colors.appBlue)
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().deleteVehicle(id: vehicle.id!, plateNumber: vehicle.plateNumber!)
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    DatabaseObjects.myVehicles.remove(at: sender.tag)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                DispatchQueue.main.async {
                    self.removeAllOverlays()
                    
                    if let message = response?.message {
                        self.showAlert(message: message, style: .alert)
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
