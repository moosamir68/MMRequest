//
//  MMError.swift
//  DonerKabab
//
//  Created by iOSDeveloper on 7/6/17.
//  Copyright © 2017 EnoOne. All rights reserved.
//

public class MMError: NSObject {
    public var errorCode:NSInteger?
    public var errorDescription:String?
    public var userInfoDIctionary:NSMutableDictionary?
    public var errorDomain:NSString?
    public var error:NSError?
    public var content:Any?
    
    public init(error:NSError){
        super.init()
        self.userInfoDIctionary = error.userInfo as? NSMutableDictionary
        self.errorCode = error.code
        self.errorDomain = error.domain as NSString
        self.error = error
        
        switch error.code {
        case -1009:
            self.errorDescription = "عدم دسترسی به اینترنت."
            break
        case -1001:
            self.errorDescription = "زمان درخواست به پایان رسید."
            break
        case -1003:
            self.errorDescription = "سروری با این اسم و مشخصات یافت نشد."
            break
        case 400:
            self.errorDescription = "سروری با این اسم و مشخصات یافت نشد."
            break
        case 401:
            self.errorDescription = error.localizedDescription
            break
        case 402:
            self.errorDescription = error.localizedDescription
            break
        case 403:
            self.errorDescription = error.localizedDescription
            break
        case 500:
            self.errorDescription = error.localizedDescription
            break
        case 501:
            self.errorDescription = error.localizedDescription
            break
        default:
            self.errorDescription = error.localizedDescription
        }
        if errorDescription != nil {
            userInfoDIctionary?.setObject(errorDescription!, forKey: NSLocalizedDescriptionKey as NSCopying)
        }
    }
    
    public init(response:MMResponse?){
        super.init()
        self.content = response?.content
        let statusCode:Int? = response?.statusCode
        self.errorCode = response?.statusCode
        switch statusCode {
        case .some(400):
            self.errorDescription = "سروری با این اسم و مشخصات یافت نشد."
            break
        case .some(400):
            self.errorDescription = "سروری با این اسم و مشخصات یافت نشد."
            break
        case .some(400):
            self.errorDescription = "سروری با این اسم و مشخصات یافت نشد."
            break
        case .some(400):
            self.errorDescription = "سروری با این اسم و مشخصات یافت نشد."
            break
        case .some(400):
            self.errorDescription = "سروری با این اسم و مشخصات یافت نشد."
            break
        case .some(400):
            self.errorDescription = "سروری با این اسم و مشخصات یافت نشد."
            break
        default:
            self.errorDescription = "سروری با این اسم و مشخصات یافت نشد."
        }
    }
    
    public init(title:String?){
        self.errorDescription = title
    }
}
