//
//  main.swift
//  swift-playground
//
//  Created by skyline on 14/12/24.
//  Copyright (c) 2014年 skyline. All rights reserved.
//

import Foundation


var params:[String:String] = ["id":"1", "category":"4", "answer":"hello", "type": "56"]

// GET

if let receivedData = Requests.get("http://httpbin.org/get", payload:params) {
    let json = JSON(data:receivedData)
    println(json.toString(pretty: true))
} else {
    println("Network Error.")
}

// POST

if let receivedData = Requests.post("http://httpbin.org/post", payload:params) {
    let json = JSON(data:receivedData)
    println(json.toString(pretty: true))
} else {
    println("Network Error.")
}

let heading = Regex(pattern: "^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)")
var text:String = "# Hello\n## Hello"

while !text.isEmpty {
    if let m = heading.match(text) {
        if let g = m.group(0) {
            text.removeRange(Range<String.Index>(start: text.startIndex, end: advance(text.startIndex, countElements(g))))
            println("Find")
            println(g)
        }
    }
}

