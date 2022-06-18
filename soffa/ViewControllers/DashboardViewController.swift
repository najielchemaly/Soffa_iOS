//
//  DashboardViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit
import GoogleMaps

class DashboardViewController: BaseViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager!
    var filteredParkings: [Parking] = [Parking]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeLocationManager()
        
        // TODO To be removed, Reload Map Pins
        self.getListOfParkings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if DatabaseObjects.user.email == nil || DatabaseObjects.user.email == "" {
            self.redirectToVC(storyboardId: StoryboardIds.EditProfileViewController, type: .Push)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

                        DispatchQueue.main.async {
                            self.setupMapView()
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
    
    func initializeLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        if #available(iOS 8.0, *) {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.startUpdatingLocation()
        
        self.textFieldSearch.delegate = self
        
        self.tableView.register(UINib.init(nibName: "SearchLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchLocationTableViewCell")
        self.tableView.tableFooterView = UIView()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DatabaseObjects.userLocation = location
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 8.0)
            self.mapView?.animate(to: camera)
            
            self.locationManager.stopUpdatingLocation()
        }
    }

    func setupMapView() {
        self.mapView.delegate = self
        self.mapView.mapType = .normal
        self.mapView.isMyLocationEnabled = true
        
        var index = 0
        for parking in DatabaseObjects.parkings {
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            
            if let location = parking.location {
                let coordinates = location.split{$0 == ","}.map(String.init)
                if let latitude = coordinates.first, let longitude = coordinates.last {
                    let latitude = Double(latitude)
                    let longitude = Double(longitude)
                    marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                }
            }
            
            let view = Bundle.main.loadNibNamed("MapPinSmallView", owner: self.view, options: nil)
            if let iconView = view?.first as? MapPinSmallView {
                iconView.labelTitle.text = parking.title
                marker.iconView = iconView
            }
            
            marker.title = String(describing: index)
            marker.map = self.mapView
            
            index += 1
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let title = marker.title {
            guard let row = Int(title) else {
                return UIView()
            }
            
            self.showPopupView(name: "MapPinView", row: row)
        }
        
        return UIView()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            let textSearch = text + string
            
            if range.location == 0 && range.length == 1 {
                tableView.isHidden = true
            } else if !textSearch.isEmpty {
                let title = textSearch.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                filteredParkings = DatabaseObjects.parkings.filter { ($0.title?.lowercased().contains(title))! }
                if filteredParkings.count > 0 {
                    tableView.reloadData()
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            } else {
                tableView.isHidden = true
            }
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredParkings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        
        let parking = filteredParkings[indexPath.row]
        if let location = parking.location {
            let coordinates = location.split{$0 == ","}.map(String.init)
            if let latitude = coordinates.first, let longitude = coordinates.last {
                let camera = GMSCameraPosition.camera(withLatitude: Double(latitude)!, longitude: Double(longitude)!, zoom: 10.0)
                self.mapView?.animate(to: camera)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationTableViewCell") as? SearchLocationTableViewCell {
            let parking = filteredParkings[indexPath.row]
            if let title = parking.title {
                cell.labbelTitle.text = title
            }
            
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
