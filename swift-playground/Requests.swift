//
//  Requests.swift
//  swift-playground
//
//  Created by skyline on 15/6/24.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation

struct Requests {
    static func get(url: String) -> NSData? {
        return self.get(url, payload: nil)
    }
    static func get(url:String, payload: [String: String]?) -> NSData? {
        var requestURL = url
        if let payload = payload {
            var parameters = [String]()
            for (key, val) in payload {
                parameters.append("\(key)=\(val)")
            }
            let query = "&".join(parameters)
            // Construct URL
            if (!url.hasSuffix("?")) {
                requestURL += "?" + query
            } else {
                requestURL += query
            }
        }
        let _url = NSURL(string: requestURL)
        let _req = NSMutableURLRequest(URL: _url!)
        let _resp:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        
        do {
            let receivedData = try NSURLConnection.sendSynchronousRequest(_req, returningResponse: _resp)
            return receivedData
        } catch _ as NSError {
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
        
        let req = NSMutableURLRequest(URL: reqURL!)
        req.HTTPMethod = "POST"
        req.HTTPBody = payload.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        let resp: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        
        do {
            let receivedData = try NSURLConnection.sendSynchronousRequest(req, returningResponse: resp)
            return receivedData
        } catch _ as NSError {
            return nil
        }
    }
}

