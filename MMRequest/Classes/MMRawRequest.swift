//
//  MMRawRequest.swift
//  DonerKabab
//
//  Created by Moosa Mir on 7/4/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

class MMRawRequest: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    var method:NSString!
    var url:NSString!
    var headers:NSMutableDictionary!
    var body:NSData?
    var cachePolicy:NSURLRequest.CachePolicy!
    var callback:(_ response:MMRawResponse?, _ error:Error?) ->Void = {_,_ in }
    var response:MMRawResponse!
    
    
    override init() {
        super.init()
        self.headers = NSMutableDictionary()
    }
    
    
    func send(callback:@escaping (_ response:MMRawResponse?, _ error:Error?) ->Void){
        
        // if you use sesstion use this code
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlRequest = self.urlRequest()
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            
            let httpResponse:HTTPURLResponse? = response as? HTTPURLResponse
            
            self.response = MMRawResponse()
            self.response.statusCode = httpResponse?.statusCode
            self.response.headers = httpResponse?.allHeaderFields as NSDictionary?
            self.response.body = NSMutableData()
            
            let dataLocal:NSMutableData? = self.response.body as? NSMutableData
            if(data != nil){
                dataLocal?.append((data)!)
            }
            
            callback(self.response, error)
            
        })
        task.resume()
        
        //if you use urlresuest uncomented this lines
//        let urlRequest = self.urlRequest()
//
//        self.callback = callback
//        let connection = NSURLConnection.init(request: urlRequest as URLRequest, delegate: self, startImmediately: false)
//        connection?.schedule(in: RunLoop.current, forMode: .commonModes)
//        connection?.start()
    }
    
    func urlRequest() ->NSURLRequest
    {
        let urlRequest = NSMutableURLRequest()
        urlRequest.httpMethod = self.method! as String
        urlRequest.url = NSURL.init(string: self.url as String)! as URL
        print(urlRequest.url!)
        urlRequest.allHTTPHeaderFields = self.headers as? [String : String]
        urlRequest.cachePolicy = self.cachePolicy
        
        if (self.body != nil)
        {
            
            print("Content length kb = ", (self.body?.length)!/1024)
            urlRequest.addValue(String(format:"%lu", (self.body?.length)!), forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody = self.body! as Data
        }
        
        return urlRequest
    }
    
    // MARK - invalidate request
    func invalidateCachedResponse(){
        
    }
    
    //MARK - delegate connection
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print(error)
        self.callback(nil, error)
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        let httpResponse:HTTPURLResponse! = response as! HTTPURLResponse
        
        self.response = MMRawResponse()
        self.response.statusCode = httpResponse.statusCode
        self.response.headers = httpResponse.allHeaderFields as NSDictionary
        self.response.body = NSMutableData()
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        let dataLocal:NSMutableData = self.response.body as! NSMutableData
        dataLocal.append(data as Data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        callback(self.response, nil)
    }
    func connection(_ connection: NSURLConnection, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
        
    }
    
}
