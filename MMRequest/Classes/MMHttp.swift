//
//  MMHttp.swift
//  DonerKabab
//
//  Created by Moosa Mir on 7/4/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

class MMHttp: NSObject {
    static func queryStringWithParams(params: NSDictionary?) ->NSString{
        if params != nil{
            if (params?.count == 0){
                return ""
            }
            
            let args = NSMutableArray()
            
            for (kind, numbers) in params!
            {
                let encodedKey = self.urlEncodedString(string:kind as! NSString)
                var encodedValue:Any?
                if let _:String = numbers as? String{
                    encodedValue = self.urlEncodedString(string:numbers as! NSString)
                }else{
                    encodedValue = numbers
                }
                let arg = String(format:"%@=%@", encodedKey, encodedValue as! CVarArg)
                
                args.add(arg)
            }
            
            return args.componentsJoined(by:"&") as NSString
        }else{
            return ""
        }
    }
    
    static func urlEncodedString(string:NSString) ->NSString{
        let escapedString = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return escapedString! as NSString
    }
}
