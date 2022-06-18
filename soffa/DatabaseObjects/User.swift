/*
 Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class User: NSObject, NSCoding {
    public var id : String?
    public var firstName : String?
    public var lastName : String?
    public var age : String?
    public var gender : String?
    public var nationality : String?
    public var phoneNumber : String?
    public var verificationCode : String?
    public var email : String?
    public var facebookID : String?
    public var facebookToken : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let User_list = User.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let User = User(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: User Instance.
     */
    
    required public override init() { }
    
    required public init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey:"id") as? String
        firstName = decoder.decodeObject(forKey:"firstName") as? String
        lastName = decoder.decodeObject(forKey:"lastName") as? String
        age = decoder.decodeObject(forKey:"dob") as? String
        gender = decoder.decodeObject(forKey:"gender") as? String
        nationality = decoder.decodeObject(forKey:"nationality") as? String
        phoneNumber = decoder.decodeObject(forKey:"phoneNumber") as? String
        verificationCode = decoder.decodeObject(forKey:"verificationCode") as? String
        email = decoder.decodeObject(forKey:"email") as? String
        facebookID = decoder.decodeObject(forKey:"facebookID") as? String
        facebookToken = decoder.decodeObject(forKey:"facebookToken") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(firstName, forKey: "firstName")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(age, forKey: "dob")
        coder.encode(gender, forKey: "gender")
        coder.encode(nationality, forKey: "nationality")
        coder.encode(phoneNumber, forKey: "phoneNumber")
        coder.encode(verificationCode, forKey: "verificationCode")
        coder.encode(email, forKey: "email")
        coder.encode(facebookID, forKey: "facebookID")
        coder.encode(facebookToken, forKey: "facebookToken")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        age = dictionary["dob"] as? String
        if let gender = dictionary["gender"] as? String {
            self.gender = gender.lowercased() == "notdefined" ? "" : gender
        }
        nationality = dictionary["nationality"] as? String
        phoneNumber = dictionary["phoneNumber"] as? String
        verificationCode = dictionary["verificationCode"] as? String
        email = dictionary["email"] as? String
        facebookID = dictionary["facebookID"] as? String
        facebookToken = dictionary["facebookToken"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.firstName, forKey: "firstName")
        dictionary.setValue(self.lastName, forKey: "lastName")
        dictionary.setValue(self.age, forKey: "dob")
        dictionary.setValue(self.gender, forKey: "gender")
        dictionary.setValue(self.nationality, forKey: "nationality")
        dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
        dictionary.setValue(self.verificationCode, forKey: "verificationCode")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.facebookID, forKey: "facebookID")
        dictionary.setValue(self.facebookToken, forKey: "facebookToken")
        
        return dictionary
    }
    
}

