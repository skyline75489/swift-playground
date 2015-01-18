//
//  Requests.swift
//  swift-playground
//
//  Created by skyline on 15/1/5.
//  Copyright (c) 2015年 skyline. All rights reserved.
//

import Foundation

struct Requests {
    
    static func get(url: String) -> NSData?{
        return self.get(url, payload: nil)
    }
    
    static func get(url: String, payload: [String:String]?) -> NSData? {
        var reqURLString:String = url
        
        if let payload = payload {
            var paraList = [String]()
            for (key, val) in payload {
                paraList.append(key + "=" + val)
            }
            let payload: String = "&".join(paraList)
            // Construct URL
            if !url.hasSuffix("?") {
                reqURLString += "?" + payload
            } else {
                reqURLString += payload
            }
        }

        let reqURL = NSURL(string: reqURLString)
        
        var req = NSMutableURLRequest(URL: reqURL!)

        var resp: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var err: NSErrorPointer = nil
        
        if let receivedData = NSURLConnection.sendSynchronousRequest(req, returningResponse: resp, error: err) {
            return receivedData
        } else {
            return nil
        }
    }
    
    static func post(url: String, payload: [String: String]) -> NSData? {
        var paraList = [String]()
        for (key, val) in payload {
            paraList.append(key + "=" + val)
        }
        let reqURL = NSURL(string: url)
        let payload: String = "&".join(paraList)
        
        var req = NSMutableURLRequest(URL: reqURL!)
        req.HTTPMethod = "POST"
        req.HTTPBody = payload.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        var resp: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var err: NSErrorPointer = nil
        
        if let receivedData = NSURLConnection.sendSynchronousRequest(req, returningResponse: resp, error: err) {
            return receivedData
        } else {
            return nil
        }
    }
}