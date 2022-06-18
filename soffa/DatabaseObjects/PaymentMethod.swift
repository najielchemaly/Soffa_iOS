/*
 Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class PaymentMethod {
    public var id : String?
    public var firstName : String?
    public var lastName : String?
    public var cardType : String?
    public var cardNumber : String?
    public var expires : String?
    public var cvv : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let PaymentMethod_list = PaymentMethod.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of PaymentMethod Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [PaymentMethod]
    {
        var models:[PaymentMethod] = []
        for item in array
        {
            models.append(PaymentMethod(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let PaymentMethod = PaymentMethod(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: PaymentMethod Instance.
     */
    
    public init() {
        
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        cardType = dictionary["cardType"] as? String
        cardNumber = dictionary["cardNumber"] as? String
        expires = dictionary["expires"] as? String
        cvv = dictionary["cvv"] as? String
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
        dictionary.setValue(self.cardType, forKey: "cardType")
        dictionary.setValue(self.cardNumber, forKey: "cardNumber")
        dictionary.setValue(self.expires, forKey: "expires")
        dictionary.setValue(self.cvv, forKey: "cvv")
        
        return dictionary
    }
    
}



