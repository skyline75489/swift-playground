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


class BlockParser {
    var tokens:[TokenBase] = [TokenBase]()
    let heading = Regex(pattern: "^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)")
    let lheading = Regex(pattern: "^([^\n]+)\n *(=|-)+ *(?:\n+|$)")
    let fences = Regex(pattern: "^ *(`{3,}|~{3,}) *(\\S+)? *\n([\\s\\S]+?)\\s\\1 *(?:\\n+|$)")
    let blockCode = Regex(pattern: "^( {4}[^\n]+\n*)+")
    
    func parse(var text:String) -> [TokenBase]{
        func forward(previous:String) {
            text.removeRange(Range<String.Index>(start: text.startIndex, end: advance(text.startIndex, countElements(previous))))
        }
        while !text.isEmpty {
            var g0 = ""
            if let m = heading.match(text) {
                parseHeading(m)
                forward(m.group(0))
                continue
            }
            if let m = fences.match(text) {
                parseFences(m)
                forward(m.group(0))
                continue
            }
            if let m = blockCode.match(text) {
                parseBlockCode(m)
                forward(m.group(0))
                continue
            }
            if let m = lheading.match(text) {
                parseLHeading(m)
                forward(m.group(0))
                continue
            }
            // In case of infinite loop
            break
        }
        return tokens
    }
    
    func parseHeading(m: RegexMatch) {
        let token = Heading(text: m.group(2), level: countElements(m.group(1)))
        tokens.append(token)
    }
    
    func parseLHeading(m: RegexMatch) {
        let level = m.group(2) == "=" ? 1 : 2;
        let token = Heading(text: m.group(1), level: level)
        tokens.append(token)
    }
    
    func parseFences(m: RegexMatch) {
        let token = BlockCode(text: m.group(3), lang: m.group(2))
        tokens.append(token)
    }
    
    func parseBlockCode(m: RegexMatch) {
        var code = m.group(0)
        let pattern = Regex(pattern: "^ {4}")
        if let match = pattern.match(code) {
            code.removeRange(match.range())
        }
        let token = BlockCode(text: code, lang: "")
        tokens.append(token)
    }
}

let blockParser = BlockParser()
if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
    let dir = dirs[0]
    let path = dir.stringByAppendingPathComponent("test.md")
    if let text = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
        for token in blockParser.parse(text) {
            println(token.render())
        }
    }
}
