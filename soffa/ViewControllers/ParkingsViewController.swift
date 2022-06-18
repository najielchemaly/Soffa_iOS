//
//  ParkingsViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class ParkingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var buttonSelectAll: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var filteredParkings: [Parking] = [Parking]()
    var isButtonSelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
        self.setupSearchBar()
        self.getListOfParkings()
        
        self.buttonSelectAll.setTitle("Deselect all", for: .normal)
        
        if parkingComingFrom != nil {
            if parkingComingFrom == ParkingComingFrom.Signup.identifier {
                self.buttonSubmit.setTitle("Get started", for: .normal)
            } else if parkingComingFrom == ParkingComingFrom.Dashboard.identifier {
                self.buttonSubmit.setTitle("Save", for: .normal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func buttonSelectAllTapped(_ sender: Any) {
        self.isButtonSelected = !self.isButtonSelected
        
        if self.isButtonSelected {
            self.buttonSelectAll.setTitle("Deselect all", for: .normal)
            DatabaseObjects.parkings.forEach({
                $0.isExcluded = false
            })
        } else {
            self.buttonSelectAll.setTitle("Select all", for: .normal)
            DatabaseObjects.parkings.forEach({
                $0.isExcluded = true
            })
        }
        
        self.filteredParkings = DatabaseObjects.parkings
        
        self.tableView.reloadData()
    }
    
    @IBAction func buttonGetStartedTapped(_ sender: Any) {
        self.showWaitOverlay(color: Colors.appBlue)
        let parkings = self.filteredParkings.filter { $0.isExcluded == true }
//        if parkings.count > 0 {
            let excludedParkings: ExcludedParking = ExcludedParking.init(parkings: parkings)
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().sendExcludedParkings(parkings: excludedParkings)
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonParkings = json["parkings"] as? [NSDictionary] {
                            DatabaseObjects.parkings = [Parking]()
                            for jsonParking in jsonParkings {
                                let parking = Parking.init(dictionary: jsonParking)
                                DatabaseObjects.parkings.append(parking!)
                            }
                            
                            DispatchQueue.main.async {
                                if parkingComingFrom == ParkingComingFrom.Signup.identifier {
                                    self.redirectToVC(storyboardId: StoryboardIds.SideMenuViewController, type: .Push)
                                } else {
                                    self.popVC()
                                }
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
            }
//        } else {
//            if parkingComingFrom == ParkingComingFrom.Signup.identifier {
//                self.redirectToVC(storyboardId: StoryboardIds.SideMenuViewController, type: .Push)
//            } else {
//                self.popVC()
//            }
//        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "ParkingTableViewCell", bundle: nil), forCellReuseIdentifier: "ParkingTableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func setupSearchBar() {
        self.searchBar.delegate = self
    }
    
    func getListOfParkings() {
        self.showWaitOverlay(color: Colors.appBlue)
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getParkings()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonParkings = json["parkings"] as? [NSDictionary] {
                        DatabaseObjects.parkings = [Parking]()
                        for jsonParking in jsonParkings {
                            let parking = Parking.init(dictionary: jsonParking)
                            parking?.isExcluded = false
                            DatabaseObjects.parkings.append(parking!)
                        }
                        
                        self.filteredParkings = DatabaseObjects.parkings
                        
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
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredParkings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ParkingTableViewCell") as? ParkingTableViewCell {
            cell.selectionStyle = .none
            
            let parking = self.filteredParkings[indexPath.row]
            cell.labelTitle.text = parking.title
            
            cell.buttonCheckbox.isSelected = parking.isExcluded == nil ? true : !parking.isExcluded!
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didSelectRow(sender:)))
            cell.addGestureRecognizer(tap)
            cell.tag = indexPath.row
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: view.tag, section: 0)) as? ParkingTableViewCell {
                cell.buttonCheckbox.isSelected = !cell.buttonCheckbox.isSelected
                
                self.filteredParkings[view.tag].isExcluded = cell.buttonCheckbox.isSelected ? false : true
            }
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredParkings = DatabaseObjects.parkings
        } else {
            let text = searchText.lowercased()
            self.filteredParkings = DatabaseObjects.parkings.filter {
                ($0.title?.lowercased().contains(text))!
            }
        }
            
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredParkings = DatabaseObjects.parkings
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
