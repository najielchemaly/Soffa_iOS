//
//  Services.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/20/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//


import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

struct ServiceName {
    
    static let getGlobalVariables = "/getGlobalVariables"
    static let registerUser = "/registerUser"
    static let login = "/login"
    static let editProfile = "/editProfile"
    static let changePassword = "/changePassword"
    static let addVehicle = "/addVehicle"
    static let getParkings = "/getParkings"
    static let sendExcludedParkings = "/sendExcludedParkings"
    static let getVehicles = "/getVehicles"
    static let deleteVehicle = "/deleteVehicle"
    static let getPaymentHistory = "/getPaymentHistory"
    static let getPaymentMethod = "/getPaymentMethod"
    static let contactUs = "/contactUs"
    static let forgotPassword = "/forgotPassword"
    static let sendSMS = "/sendSMS"
    static let verifyUser = "/verifyUser"
    static let logout = "/logout"
    static let facebookLogin = "/facebookLogin"
    static let searchHistory = "/searchHistory"
    static let deletePayment = "/deletePayment"
    static let setDefaultPayment = "/setDefaultPayment"
    static let addPaymentMethod = "/addPaymentMethod"
    
}

enum ResponseStatus: Int {
    
    case SUCCESS = 1
    case FAILURE = 0
    case CONNECTION_TIMEOUT = -1
    case FACEBOOK_UNAUTHORIZED = -2
    
}

enum ResponseMessage: String {
    
    case SERVER_UNREACHABLE = "An error has occured, please try again."
    case CONNECTION_TIMEOUT = "Check your internet connection."
    case UNAUTHORIZED = "Unauthorized Access"
    
}

class ResponseData {
    
    var status: Int = ResponseStatus.SUCCESS.rawValue
    var message: String = String()
    var json: [NSDictionary]? = [NSDictionary]()
    var jsonObject: JSON? = JSON((Any).self)
    
}

class Services {
    
//    // LOCAL
//    private let BaseUrl = "http://192.168.1.103/api"

    // LIVE
//    private let BaseUrl = "http://soffa.mitch.solutions/api"
    private let BaseUrl = "http://35.156.151.36/api"
    
    private let Suffix = ""
    private static var _AccessToken: String = ""
    var ACCESS_TOKEN: String {
        get {
            if let token = UserDefaults.standard.string(forKey: Keys.AccessToken.rawValue) {
                Services._AccessToken = token
            }
            
            return Services._AccessToken
        }
    }
    private let GRANT_TYPE = "password"
    private static var _MediaUrl: String = ""
    var MediaUrl: String {
        get {
            return Services._MediaUrl
        }
        set {
            Services._MediaUrl = newValue
        }
    }
    
    func getGlobalVariables() -> ResponseData? {
        
        let serviceName = ServiceName.getGlobalVariables
        return makeHttpRequest(method: .get, serviceName: serviceName)
    }
    
    func registerUser(firstName: String, lastName: String, age: String, gender: String, nationality: Int, phoneNumber: String, email: String, password: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "firstName": firstName,
            "lastName": lastName,
            "dob": age,
            "gender": gender,
            "nationality": nationality,
            "phoneNumber": phoneNumber,
            "email": email,
            "password": password
        ]
        
        let serviceName = ServiceName.registerUser
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func login(email: String, password: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "email": email,
            "password": password
//            "grant_type": GRANT_TYPE
        ]
        
        let serviceName = ServiceName.login
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func editProfile(firstName: String, lastName: String, age: String, gender: String, nationality: Int, phoneNumber: String, email: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "firstName": firstName,
            "lastName": lastName,
            "dob": age,
            "gender": gender,
            "nationality": nationality,
            "phoneNumber": phoneNumber,
            "email": email
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.editProfile
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func changePassword(oldPassword: String, newPassword: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.changePassword
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func addVehicle(plateNumber: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "plateNumber": plateNumber
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.addVehicle
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func getParkings() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.getParkings
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func sendExcludedParkings(parkings: ExcludedParking) -> ResponseData? {
        
        let parameters: Parameters = parkings.toDict()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        do {
            let jsonData: NSData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)!
            print(jsonString)
        } catch  {
            print("Error")
        }
        
        let serviceName = ServiceName.sendExcludedParkings
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func getVehicles() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.getVehicles
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func deleteVehicle(id: Int, plateNumber: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "id": id,
            "plateNumber": plateNumber
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.deleteVehicle
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func getPaymentHistory() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.getPaymentHistory
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func getPaymentMethod() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.getPaymentMethod
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func contactUs(name: String, email: String, purpose: String, subject: String, description: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "name": name,
            "email": email,
            "purpose": purpose,
            "subject": subject,
            "description": description
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.contactUs
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func forgotPassword(email: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "email": email
        ]
        
        let serviceName = ServiceName.forgotPassword
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func sendSMS(phoneNumber: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "phoneNumber": phoneNumber
        ]
        
        let serviceName = ServiceName.sendSMS
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func verifyUser() -> ResponseData? {
        
        let parameters: Parameters = [
            "verified": "true"
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.verifyUser
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func logout() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.logout
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func facebookLogin(user: User) -> ResponseData? {
        
        let parameters: Parameters = [
            "facebookID": user.facebookID ?? "",
            "facebookToken": user.facebookToken ?? "",
            "firstName": user.firstName ?? "",
            "email": user.email ?? "",
            "gender": user.gender ?? "",
        ]
        
        let serviceName = ServiceName.facebookLogin
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func searchHistory(text: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "text": text
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.searchHistory
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func deletePayment(id: String, cvv: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "id": id,
            "cvv": cvv
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.deletePayment
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func setDefaultPayment(id: String, cvv: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "id": id,
            "cvv": cvv
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let serviceName = ServiceName.setDefaultPayment
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func sendLPRImage2(imageFile: UIImage) -> ResponseData? {
        
        let imageData = imageFile.jpeg(.medium)
        
        let parameters: Parameters = [
            "imageData": imageData?.base64EncodedString() ?? "error"
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        return makeHttpRequest(method: .post, serviceName: "/sendLPRImage", parameters: parameters, headers: headers)
    }
    
    func sendLPRImage(imageFile : UIImage, completion:@escaping(_:ResponseData)->Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + ACCESS_TOKEN
        ]
        
        let imageData = imageFile.jpeg(.medium)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, to: BaseUrl + "/sendLPRImage", headers: headers)
        { (result) in
            let responseData = ResponseData()
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                })
                
                upload.responseJSON { response in
                    
                    if let json = response.result.value as? NSDictionary {
                        responseData.status = ResponseStatus.SUCCESS.rawValue
                        responseData.json = [json]
                        
                        completion(responseData)
                    } else {
                        responseData.status = ResponseStatus.FAILURE.rawValue
                        responseData.json = nil
                        completion(responseData)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                responseData.status = ResponseStatus.FAILURE.rawValue
                responseData.json = nil
                completion(responseData)
            }
        }
    }
    
    // MARK: /************* SERVER REQUEST *************/
    
    private func makeHttpRequest(method: HTTPMethod, serviceName: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> ResponseData? {
        
        let response = manager.request(BaseUrl + Suffix + serviceName, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(options: .allowFragments)
        let responseData = ResponseData()
        responseData.status = ResponseStatus.FAILURE.rawValue
        responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
        
        if let token = response.response?.allHeaderFields[Keys.Access_Token.rawValue] as? String {
            UserDefaults.standard.set(token, forKey: Keys.AccessToken.rawValue)
        }
        if let jsonArray = response.result.value as? [NSDictionary] {
            let json = jsonArray.first
            if let status = json!["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json!["message"] as? String {
                if message == ResponseMessage.UNAUTHORIZED.rawValue {
                    if let baseVC = currentVC as? BaseViewController {
                        baseVC.logout()
                    }
                    
//                    return nil
                }
                
                responseData.message = message
            }
            if let message = json!["message"] as? Bool {
                responseData.message = String(message)
            }
            if let token = json![Keys.Access_Token.rawValue] as? String {
                UserDefaults.standard.set(token, forKey: Keys.AccessToken.rawValue)
            }
            
            if let json = jsonArray.last {
                responseData.json = [json]
            }
            
        } else if let json = response.result.value as? NSDictionary {
            if let status = json["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json["message"] as? String {
                if message == ResponseMessage.UNAUTHORIZED.rawValue {
                    if let baseVC = currentVC as? BaseViewController {
                        baseVC.logout()
                    }
                    
//                    return nil
                }
                
                responseData.message = message
            }
            if let message = json["message"] as? Bool {
                responseData.message = String(message)
            }
            if let token = json[Keys.Access_Token.rawValue] as? String {
                UserDefaults.standard.set(token, forKey: Keys.AccessToken.rawValue)
            }
            
            responseData.json = [json]
            
        } else if let jsonArray = response.result.value as? NSArray {
            if let jsonStatus = jsonArray.firstObject as? NSDictionary {
                if let status = jsonStatus["status"] as? Int {
                    responseData.status = status
                }
                if let message = jsonStatus["message"] as? String {
                    if message == ResponseMessage.UNAUTHORIZED.rawValue {
                        if let baseVC = currentVC as? BaseViewController {
                            baseVC.logout()
                        }
                        
//                        return nil
                    }
                    
                    responseData.message = message
                }
            }
            
            if let jsonData = jsonArray.lastObject as? NSArray {
                responseData.json = [NSDictionary]()
                for jsonObject in jsonData {
                    if let json = jsonObject as? NSDictionary {
                        responseData.json?.append(json)
                    }
                }
            }
        } else {
            responseData.status = ResponseStatus.FAILURE.rawValue
            responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
            responseData.json = nil
        }
        
        return responseData
        
    }
    
    let manager: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 60
        return SessionManager(configuration: configuration)
        
    }()
    
    func getBaseUrl() -> String {
        return self.BaseUrl
    }
    
    func getPaymentUrl() -> String {
        return self.BaseUrl + ServiceName.addPaymentMethod
    }
    
    static func getMediaUrl() -> String {
        return _MediaUrl
    }
    
    static func setMediaUrl(url: String) {
        _MediaUrl = url
    }
}
