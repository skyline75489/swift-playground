//
//  main.swift
//  swift-playground
//
//  Created by skyline on 14/12/24.
//  Copyright (c) 2014年 skyline. All rights reserved.
//

import Foundation

// Async
class MyNSURLConnectionDelegate: NSObject, NSURLConnectionDataDelegate {
    private var receivedData:NSData?
    override init() {
        receivedData = nil;
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        receivedData = data
        println(receivedData)
    }
}


func GET(url:String, payload:[String:String]) -> JSON? {
    var paraList = [String]()
    for (key, val) in payload {
        paraList.append(key + "=" + val)
    }
    let payload: String = "&".join(paraList)
    var req_url_str:String = url
    if !url.hasSuffix("?") {
        req_url_str += "?" + payload
    } else {
        req_url_str += payload
    }
    let req_url = NSURL(string: req_url_str)

    let req = NSURLRequest(URL: req_url!)
    var resp: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
    var err: NSErrorPointer = nil

    if let receivedData = NSURLConnection.sendSynchronousRequest(req, returningResponse: resp, error: err) {
        let json = JSON(data: receivedData)
        return json
    } else {
        return nil
    }
}

var paraDict:[String:String] = ["id":"1", "category":"4", "answer":"hello", "type": "56"]

if let json = GET("http://httpbin.org/get", paraDict) {
    println(json.toString(pretty:true))
} else {
    println("Network Error.")
}




