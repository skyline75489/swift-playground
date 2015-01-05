//
//  main.swift
//  swift-playground
//
//  Created by skyline on 14/12/24.
//  Copyright (c) 2014年 skyline. All rights reserved.
//

import Foundation


/*
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
*/

let heading = Regex(pattern: "^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)")

var text:String = "# Hello\n## Hello \n###Hi"
var tokens:[TokenBase] = [TokenBase]()

while !text.isEmpty {
    if let m = heading.match(text) {
        var _level = 1;
        var _text = ""
        if let g0 = m.group(0) {
            text.removeRange(Range<String.Index>(start: text.startIndex, end: advance(text.startIndex, countElements(g0))))
        }
        if let g1 = m.group(1) {
            _level = countElements(g1)
        }
        if let g2 = m.group(2) {
            _text = g2
        }
        let h = Heading(text: _text, level: _level)
        tokens.append(h)
    }
}

for token in tokens {
    println(token.render())
}
