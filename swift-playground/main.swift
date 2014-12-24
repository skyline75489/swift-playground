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

let url = NSURL(string: "http://httpbin.org/get")
let req = NSURLRequest(URL: url!)
var resp:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
var err:NSErrorPointer = nil

let receivedData = NSURLConnection.sendSynchronousRequest(req, returningResponse: resp, error: err)

let str = NSString(data: receivedData!, encoding: NSUTF8StringEncoding)
println(str)
