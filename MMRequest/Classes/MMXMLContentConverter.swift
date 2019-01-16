//
//  MMXMLContentConverter.swift
//  DonerKabab
//
//  Created by iOSDeveloper on 7/8/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

class MMXMLContentConverter: NSObject, MMConvertContent {
    func supportsContentType(contentType:NSString) ->Bool?
    {
        if(contentType.contains("application/xml") || contentType.contains("text/xml")){
            return true
        }
        
        return false
    }
    
    func dataFromContent(content:Any?, contentType:NSString) ->NSData?
    {
        if content != nil {
            return nil
        }else{
            return nil
        }
    }
    
    func contentFromData(data:NSData?, contentType:NSString) ->Any?
    {
        if data != nil{
            return nil
        }else{
            return nil
        }
    }
}
