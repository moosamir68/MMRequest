//
//  MMResponse.swift
//  DonerKabab
//
//  Created by Moosa Mir on 7/4/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

public class MMResponse: NSObject {
    public var statusCode:NSInteger?
    public var headers:NSDictionary?
    public var contentType:NSString?
    public var body:NSData?
    public var content:Any?
}
