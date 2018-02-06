//
//  MMExtentions.swift
//  DonerKabab
//
//  Created by Moosa Mir on 7/4/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

public protocol MMConvertContent {
    func supportsContentType(contentType:NSString) ->Bool?
    func dataFromContent(content:Any?, contentType:NSString) ->NSData?
    func contentFromData(data:NSData?, contentType:NSString) ->Any?
}
