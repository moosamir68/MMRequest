//
//  MMFormDataContentConverter.swift
//  DonerKabab
//
//  Created by iOSDeveloper on 7/5/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

class MMFormDataContentConverter: NSObject, MMConvertContent {

    func supportsContentType(contentType:NSString) ->Bool?
    {
        if(contentType.contains("application/form-data")){
            return true
        }
        
        return false
    }
    
    func dataFromContent(content:Any?, contentType:NSString) ->NSData?
    {
        if content != nil {
            let queryString = MMHttp.queryStringWithParams(params: content as? NSDictionary)
            let data = queryString.data(using: String.Encoding.ascii.rawValue)! as NSData
            return data
        }else{
            return nil
        }
    }
    
    func contentFromData(data:NSData?, contentType:NSString) ->Any?
    {
        return nil
    }
}
