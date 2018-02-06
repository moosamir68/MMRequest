//
//  MMRequest.swift
//  DonerKabab
//
//  Created by Moosa Mir on 7/4/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

public class MMRequest: NSObject {
    public var method:NSString!
    public var protocoll:NSString!
    public var subdomain:NSString!
    public var baseURL:NSString!
    public var path:NSString!
    public var pathParams:NSMutableArray?
    public var queryParams:NSMutableDictionary?
    public var headers:NSMutableDictionary!
    public var contentType:NSString!
    public var body:NSData?
    public var content:Any?
    public var cachePolicy:NSURLRequest.CachePolicy!
    var rawRequest:MMRawRequest!
    var contentConverters:[MMConvertContent]!
    public static let sharedInstance = MMRequest()
    
    public override init() {
        super.init()
        self.method = "GET"
        self.protocoll = "http"
        self.subdomain = ""
        self.baseURL = ""
        self.path = ""
        self.headers = NSMutableDictionary()
        self.contentType = "application/x-www-form-urlencoded"
        self.content = NSMutableDictionary()
        self.contentConverters = [MMConvertContent]()
        self.contentConverters.append(MMJsonContentConverter())
        self.contentConverters.append(MMFormURLEncodedContentConverter())
        self.contentConverters.append(MMFormDataContentConverter())
        self.contentConverters.append(MMXMLContentConverter())
        self.cachePolicy = NSURLRequest.CachePolicy(rawValue: 0)
        self.queryParams = NSMutableDictionary()
        self.pathParams = NSMutableArray()
    }
    
    public func send(callback:@escaping (_ response:MMResponse?, _ error:MMError?) ->Void){
        let rawRequest:MMRawRequest = self.baseRequest()
        rawRequest.send { (rawResponse, error) in
            if (error != nil)
            {
                let error:MMError = MMError.init(error: error! as NSError)
                callback(nil, error)
                return
            }
            
            let response = MMResponse()
            response.statusCode = rawResponse?.statusCode
            response.headers = rawResponse?.headers
            if (rawResponse!.headers?["Content-Type"]) != nil {
                response.contentType = MMRequest.contentTypeFromHeader(contentType: rawResponse!.headers?.object(forKey: "Content-Type") as! NSString)
            }

            response.body = rawResponse?.body
            response.content = self.contentFromData(data:response.body, contentType:response.contentType)
            callback(response, nil)
        }
    }
    
    func baseRequest() ->MMRawRequest
    {
        let url = MMRequest.urlWithProtocol(protocoll:self.protocoll, baseURL:self.baseURL, subdomain:self.subdomain, path:self.path, pathParams:self.pathParams, queryParams:self.queryParams)
        
        print(url)
        let contentType = self.contentType
        let body:NSData?
        if self.body != nil {
            body = self.body
        }else{
            body = self.dataFromContent(content: self.content, contentType: contentType)
        }
        
        let httpRequest = MMRawRequest()
        httpRequest.method = self.method
        httpRequest.url = url
        httpRequest.headers.addEntries(from: self.headers as! [AnyHashable : Any])
        httpRequest.cachePolicy = self.cachePolicy
        
        if (body != nil)
        {
            httpRequest.headers.setValue(contentType, forKey: "Content-Type")
            httpRequest.body = body
        }
        
        return httpRequest
    }
    
    //MARK - Class Method
    static func urlWithProtocol(protocoll:NSString, baseURL:NSString, subdomain:NSString, path:NSString, pathParams:NSArray?, queryParams:NSDictionary?) -> NSString
    {
        var rewrittenPath:NSString = ""
        var queryString:NSString = ""
        
        rewrittenPath = MMRequest.rewrittenPath(path:path, withParams:pathParams)
        queryString = MMHttp.queryStringWithParams(params: queryParams)
        var url = baseURL
        
        if (subdomain.length > 0){
            url = String(format: "%@.%@", subdomain, url) as NSString
        }
        
        if (rewrittenPath.length > 0){
            url = String(format: "%@/%@", url, rewrittenPath) as NSString
        }
        
        if (queryString.length > 0){
            url = String(format: "%@?%@", url, queryString) as NSString
        }
        
        url = String(format: "%@://%@", protocoll, url) as NSString
        return url
    }
    
    static func rewrittenPath(path:NSString, withParams:NSArray?) -> NSString
    {
        if withParams != nil{
            if (withParams?.count == 0){
                return path
            }
            
            var tempPath:NSString = path
            //
            for param in withParams!{
                let tempParam = MMHttp.urlEncodedString(string: param as! NSString )
                tempPath = String(format: "%@/%@", tempPath,tempParam) as NSString
            }
            return tempPath
        }else{
            return path
        }
    }
    
    static func contentTypeFromHeader(contentType:NSString) ->NSString
    {
        let range:NSRange! = contentType.range(of: "")
        
        if (range.location == NSNotFound){
            return contentType
        }
        return contentType.substring(to: range.location).trimmingCharacters(in: NSCharacterSet.whitespaces) as NSString
    }
    
    
    func dataFromContent(content:Any?, contentType:NSString?) ->NSData?
    {
        if (content == nil){
            return nil
        }
        
        for contentConverter in self.contentConverters{
            if contentConverter.supportsContentType(contentType:contentType!)!{
                return contentConverter.dataFromContent(content:content, contentType:contentType!)
            }
        }
        return nil
    }
    
    func contentFromData(data:NSData?, contentType:NSString?) -> Any?
    {
        if (contentType == nil){
            return nil
        }
        
        for contentConverter in self.contentConverters{
            if (contentConverter.supportsContentType(contentType:contentType!))!{
                return contentConverter.contentFromData(data:data, contentType:contentType!)
            }
        }
        
        return nil
    }
}
