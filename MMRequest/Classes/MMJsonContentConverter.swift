//
//  MMJsonContentConverter.swift
//  DonerKabab
//
//  Created by Moosa Mir on 7/4/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

class MMJsonContentConverter: NSObject, MMConvertContent {
    
    func supportsContentType(contentType:NSString) ->Bool?
    {
        if(contentType.caseInsensitiveCompare("application/json") == .orderedSame){
            return true
        }
        
        return false
    }
    
    func dataFromContent(content:Any?, contentType:NSString) ->NSData?
    {
        if(content != nil){
            do {
                let jsonData:NSData? = try JSONSerialization.data(withJSONObject: content!, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
                return jsonData
            } catch {
                print("something went wrong with parsing json: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
    
    func contentFromData(data:NSData?, contentType:NSString) ->Any?
    {
        if data != nil{
            do {
                let json = try JSONSerialization.jsonObject(with: data! as Data, options:JSONSerialization.ReadingOptions.allowFragments)
                return json
            } catch {
                print("json error: \(error.localizedDescription)")
                return error
            }
        }else{
            return nil
        }
    }
}
