//
//  DatabaseObjects.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/22/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import Foundation
import CoreLocation

class DatabaseObjects {
    
    static var FIREBASE_TOKEN: String = String()
    static var TermsAndConditions: String = String()
    static var PrivacyPolicy: String = String()
    static var AboutUs: String  = String()
    static var plateNumber: String = String()
    static var selectedCountryId: Int = Int()
    static var isInReview: Bool = Bool()
    static var userLocation: CLLocation!
    
    static var user: User = User()
    static var tempUser: User = User()
    static var countries: [Country] = [Country]()
    static var parkings: [Parking] = [Parking]()
    static var myVehicles: [Vehicle] = [Vehicle]()
    static var paymentHistories: [PaymentHistory] = [PaymentHistory]()
    static var paymentMethods: [PaymentMethod] = [PaymentMethod]()
    
}
