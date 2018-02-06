//
//  MMUserAgent.swift
//  DonerKabab
//
//  Created by iOSDeveloper on 7/8/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

public class MMUserAgent: NSObject {
    public static func userAgent() ->NSString{
        let version:NSString = (Bundle.main.infoDictionary! as NSDictionary).object(forKey: "CFBundleShortVersionString") as! NSString
        let build:NSString = (Bundle.main.infoDictionary! as NSDictionary).object(forKey: "CFBundleVersion") as! NSString
        let deviceModel:NSString = UIDevice.current.model as NSString
        let deviceSystemName:NSString = UIDevice.current.systemName as NSString
        let deviceSystemVersion:NSString = UIDevice.current.systemVersion as NSString
        let locale:NSString = NSLocale.current.identifier as NSString
        let userAgent = String(format:"com.frikadell.Frikadell.ios.iphone/%@ (%@; %@; %@; %@; %@)", version, build, deviceModel, deviceSystemName, deviceSystemVersion, locale)
        return userAgent as NSString
    }
}
