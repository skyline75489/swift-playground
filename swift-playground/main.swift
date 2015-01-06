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
    let newline = Regex(pattern: "^\n+")
    let heading = Regex(pattern: "^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)")
    let lheading = Regex(pattern: "^([^\n]+)\n *(=|-)+ *(?:\n+|$)")
    let fences = Regex(pattern: "^ *(`{3,}|~{3,}) *(\\S+)? *\n([\\s\\S]+?)\\s\\1 *(?:\\n+|$)")
    let blockCode = Regex(pattern: "^( {4}[^\n]+\n*)+")
    let hrule = Regex(pattern: "^ {0,3}[-*_](?: *[-*_]){2,} *(?:\n+|$)")
    let blockQuote = Regex(pattern: "^( *>[^\n]+(\n[^\n]+)*\n*)+")
    
    func parse(var text:String) -> [TokenBase]{
        func forward(length:Int) {
            text.removeRange(Range<String.Index>(start: text.startIndex, end: advance(text.startIndex,length)))
        }
        while !text.isEmpty {
            let token = getNextToken(text)
            tokens.append(token.token)
            forward(token.length)
        }
        return tokens
    }
    
    func getNextToken(text:String) -> (token:TokenBase, length:Int) {
        if let m = heading.match(text) {
            return (parseHeading(m), countElements(m.group(0)))
        }
        if let m = lheading.match(text) {
            return (parseLHeading(m), countElements(m.group(0)))
        }
        if let m = fences.match(text) {
            return (parseFences(m), countElements(m.group(0)))
        }
        if let m = blockCode.match(text) {
            return (parseBlockCode(m), countElements(m.group(0)))
        }
        if let m = hrule.match(text) {
            return (parseHRule(m), countElements(m.group(0)))
        }
        if let m = newline.match(text) {
            return (parseNewline(m), countElements(m.group(0)))
        }
        return (TokenNone(), 0)
    }
    
    func parseNewline(m: RegexMatch) -> TokenBase {
        let length = countElements(m.group(0))
        if length > 1 {
            return NewLine()
        }
        return TokenNone()
    }
    func parseHeading(m: RegexMatch) -> TokenBase {
        return Heading(text: m.group(2), level: countElements(m.group(1)))
    }
    
    func parseLHeading(m: RegexMatch) -> TokenBase {
        let level = m.group(2) == "=" ? 1 : 2;
        return Heading(text: m.group(1), level: level)
    }
    
    func parseFences(m: RegexMatch) -> TokenBase {
        return BlockCode(text: m.group(3), lang: m.group(2))
    }
    
    func parseBlockCode(m: RegexMatch) -> TokenBase {
        var code = m.group(0)
        let pattern = Regex(pattern: "^ {4}")
        if let match = pattern.match(code) {
            code.removeRange(match.range())
        }
        return BlockCode(text: code, lang: "")
    }
    
    func parseHRule(m: RegexMatch) -> TokenBase {
        return HRule()
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
