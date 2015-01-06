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
    var definedLinks = [String:[String:String]]()
    
    var tokens:[TokenBase] = [TokenBase]()
    let defLinks = Regex(pattern: "^ *\\[([^^\\]]+)\\]: *<?([^\\s>]+)>?(?: +[\"(]([^\n]+)[\")])? *(?:\n+|$)")
    let defFootnotes = Regex(pattern:"^\\[\\^([^\\]]+)\\]: *([^\n]*(?:\n+|$)(?: {1,}[^\n]*(?:\n+|$))*)")
    let newline = Regex(pattern: "^\n+")
    let heading = Regex(pattern: "^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)")
    let lheading = Regex(pattern: "^([^\n]+)\n *(=|-)+ *(?:\n+|$)")
    let fences = Regex(pattern: "^ *(`{3,}|~{3,}) *(\\S+)? *\n([\\s\\S]+?)\\s\\1 *(?:\\n+|$)")
    let blockCode = Regex(pattern: "^( {4}[^\n]+\n*)+")
    let hrule = Regex(pattern: "^ {0,3}[-*_](?: *[-*_]){2,} *(?:\n+|$)")
    let blockQuote = Regex(pattern: "^( *>[^\n]+(\n[^\n]+)*\n*)+")
    
    func forward(inout text:String, length:Int) {
        text.removeRange(Range<String.Index>(start: text.startIndex, end: advance(text.startIndex,length)))
    }
    
    func parse(var text:String) -> [TokenBase]{
        while !text.isEmpty {
            let token = getNextToken(text)
            tokens.append(token.token)
            forward(&text, length:token.length)
        }
        return tokens
    }
    
    func getNextToken(text:String) -> (token:TokenBase, length:Int) {
        if let m = newline.match(text) {
            return (parseNewline(m), countElements(m.group(0)))
        }
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
        if let m = blockQuote.match(text) {
            return (parseBlockQuote(m), countElements(m.group(0)))
        }
        if let m = defLinks.match(text) {
            parseDefLinks(m)
            return (TokenNone(), countElements(m.group(0)))
        }
        return (TokenBase(type: " ", text: text.substringToIndex(advance(text.startIndex, 1))) , 1)
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
        var code = String(m.group(0))
        let pattern = Regex(pattern: "^ {4}")
        if let match = pattern.match(code) {
            code.removeRange(match.range())
        }
        return BlockCode(text: code, lang: "")
    }
    
    func parseHRule(m: RegexMatch) -> TokenBase {
        return HRule()
    }
    
    func parseBlockQuote(m: RegexMatch) -> TokenBase {
        let start = BlockQuote(type: "blockQuoteStart", text: "")
        tokens.append(start)
        var cap = m.group(0)
        
        let pattern = Regex(pattern: "^ *> ?")
        var previousIndex = 0
        var newCap = ""
        
        // NSRegularExpressoin doesn't support replacement in multilines
        // We have to manually split the captured String into multiple lines
        let lines = cap.componentsSeparatedByString("\n")
        for (index, var everyMatch) in enumerate(lines) {
            if let match = pattern.match(everyMatch) {
                everyMatch.removeRange(match.range())
                newCap += everyMatch + "\n"
            }
        }
        self.parse(newCap)
        return BlockQuote(type: "blockQuoteEnd", text: "")
    }
    
    func parseDefLinks(m: RegexMatch) {
        let key = m.group(1)
        definedLinks[key] = [
            "link": m.group(2),
            "title": m.matchedString.count > 3 ? m.group(3) : ""
        ]
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
