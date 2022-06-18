/*
 Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Parking: JSONable {
    public var id : Int?
    public var title : String?
    public var description : String?
    public var location : String?
    public var accessHours : String?
    public var isExcluded : Bool?
    public var phoneNumber : String?
    public var imgUrl: String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Parking_list = Parking.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Parking Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Parking]
    {
        var models:[Parking] = []
        for item in array
        {
            models.append(Parking(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let Parking = Parking(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Parking Instance.
     */
    
    public init(id: Int, title: String, description: String, location: String, accessHours: String, isExcluded: Bool, phoneNumber: String, imgUrl: String) {
        self.id = id
        self.title = title
        self.description = description
        self.location = location
        self.accessHours = accessHours
        self.isExcluded = isExcluded
        self.phoneNumber = phoneNumber
        self.imgUrl = imgUrl
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        location = dictionary["location"] as? String
        accessHours = dictionary["accessHours"] as? String
        isExcluded = dictionary["isExcluded"] as? Bool
        phoneNumber = dictionary["phoneNumber"] as? String
        imgUrl = dictionary["imgUrl"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.location, forKey: "location")
        dictionary.setValue(self.accessHours, forKey: "accessHours")
        dictionary.setValue(self.isExcluded, forKey: "isExcluded")
        dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
        dictionary.setValue(self.imgUrl, forKey: "imgUrl")
        
        return dictionary
    }
    
}


