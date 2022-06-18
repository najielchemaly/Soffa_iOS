//
//  CountriesView.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/24/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class CountriesView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var topView: UIView!
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "CountriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CountriesTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseObjects.countries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let country = DatabaseObjects.countries[indexPath.row]
        if let signupVC = currentVC as? SignupViewController {
            signupVC.textFieldCountry.text = country.CountryName
            signupVC.textFieldPhoneNumber.text = "+" + country.CallingCode! + " "
            signupVC.selectedCountryCodeLength = (signupVC.textFieldPhoneNumber.text?.count)!
            
            signupVC.hidePopupView()
        } else if let editProfileVC = currentVC as? EditProfileViewController {
            editProfileVC.textFieldRegion.text = country.CountryName
            editProfileVC.textFieldPhoneNumber.text = "+" + country.CallingCode! + " "
            editProfileVC.selectedCountryCodeLength = (editProfileVC.textFieldPhoneNumber.text?.count)!
            
            editProfileVC.hidePopupView()
        }
        
        if let countryId = country.ID {
            DatabaseObjects.selectedCountryId = countryId
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesTableViewCell") as? CountriesTableViewCell {
            
            cell.labelName.text = DatabaseObjects.countries[indexPath.row].CountryName

            return cell
        }
        
        return UITableViewCell()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
