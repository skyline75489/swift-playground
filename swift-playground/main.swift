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

var payload:String
var paraList = [String]()
var paraDict:[String:String] = ["id":"1", "category":"4", "answer":"hello", "type": "56"]

for (key, val) in paraDict {
    paraList.append(key + "=" + val)
}

payload = "&".join(paraList)

let url = NSURL(string: "http://httpbin.org/get?" + payload)
let req = NSURLRequest(URL: url!)
var resp:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
var err:NSErrorPointer = nil

if let receivedData = NSURLConnection.sendSynchronousRequest(req, returningResponse: resp, error: err) {
    
    // Optional(String)
    //let str = NSString(data: receivedData, encoding: NSUTF8StringEncoding)
    
    // JSON Object
    let json = JSON(data:receivedData)
    let args = json["args"]
    println("The Arguments:")
    println(args.toString(pretty: true))
    println("The Headers:")
    // subscript(key:String) -> JSON
    let headers = json["headers"]
    println(headers.toString(pretty: true))
}




