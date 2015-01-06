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
    var tokens = [TokenBase]()
    var grammarNameMap = [Regex:String]()
    var grammarList = [Regex]()
    
    init() {
        addGrammar("defLinks", regex: Regex(pattern:"^ *\\[([^^\\]]+)\\]: *<?([^\\s>]+)>?(?: +[\"(]([^\n]+)[\")])? *(?:\n+|$)"))
        addGrammar("defFootnotes", regex: Regex(pattern:"^\\[\\^([^\\]]+)\\]: *([^\n]*(?:\n+|$)(?: {1,}[^\n]*(?:\n+|$))*)"))
        addGrammar("newline", regex: Regex(pattern: "^\n+"))
        addGrammar("heading", regex: Regex(pattern: "^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)"))
        addGrammar("lheading", regex: Regex(pattern: "^([^\n]+)\n *(=|-)+ *(?:\n+|$)"))
        addGrammar("fences", regex: Regex(pattern: "^ *(`{3,}|~{3,}) *(\\S+)? *\n([\\s\\S]+?)\\s\\1 *(?:\\n+|$)"))
        addGrammar("blockCode", regex: Regex(pattern: "^( {4}[^\n]+\n*)+"))
        addGrammar("hrule", regex: Regex(pattern: "^ {0,3}[-*_](?: *[-*_]){2,} *(?:\n+|$)"))
        addGrammar("blockQuote", regex: Regex(pattern: "^( *>[^\n]+(\n[^\n]+)*\n*)+"))
        addGrammar("text", regex: Regex(pattern: "^[^\n]+"))
    }
    
    func addGrammar(name:String, regex:Regex) {
        grammarNameMap[regex] = name
        grammarList.append(regex)
    }
    
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
    
    func chooseParseFunctionForGrammar(name:String) -> (RegexMatch) -> TokenBase {
        switch name {
        case "newline":
            return parseNewline
        case "heading":
            return parseHeading
        case "lheading":
            return parseLHeading
        case "fences":
            return parseFences
        case "blockCode":
            return parseBlockCode
        case "hrule":
            return parseHRule
        case "blockQuote":
            return parseBlockQuote
        case "text":
            return parseText
        default:
            return parseText
        }
    }
    
    func getNextToken(text:String) -> (token:TokenBase, length:Int) {
        for regex in grammarList {
            if let m = regex.match(text) {
                let name = grammarNameMap[regex]! // Name won't be nil
                let forwardLength = countElements(m.group(0))
                
                // Special case
                if name == "defLinks" {
                    parseDefLinks(m)
                    return (TokenNone(), forwardLength)
                }
                
                let parseFunction = chooseParseFunctionForGrammar(name)
                let tokenResult = parseFunction(m)
                return (tokenResult, forwardLength)
            }
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
    
    func parseText(m: RegexMatch) -> TokenBase {
        return TokenBase(type: "text", text: m.group(0))
    }
}

class InlineParser {
    var links = [String:[String:String]]()
    var grammarNameMap = [Regex:String]()
    var grammarList = [Regex]()
    
    init() {
        addGrammar("refLinks", regex: Regex(pattern: "^!?\\[((?:\\[[^^\\]]*\\]|[^\\[\\]]|\\](?=[^\\[]*\\]))*)\\]\\s*\\[([^^\\]]*)\\]"))
        addGrammar("code", regex: Regex(pattern: "^(`+)\\s*(.*?[^`])\\s*\\1(?!`)"))
        addGrammar("text", regex: Regex(pattern: "^[\\s\\S]+?(?=[\\\\<!\\[_*`~]|https?://| {2,}\n|$)"))
    }
    
    func addGrammar(name:String, regex:Regex) {
        grammarNameMap[regex] = name
        grammarList.append(regex)
    }

    func forward(inout text:String, length:Int) {
        text.removeRange(Range<String.Index>(start: text.startIndex, end: advance(text.startIndex,length)))
    }
    
    func parse(inout text:String) {
        var result = ""
        while !text.isEmpty {
            let token = getNextToken(text)
            result += token.token.render()
            forward(&text, length:token.length)
        }
        text = result
    }
    
    
    func chooseOutputFunctionForGrammar(name:String) -> (RegexMatch) -> TokenBase {
        switch name {
        case "refLinks":
            return outputRefLink
        case "code":
            return outputCode
        case "text":
            return outputText
        default:
            return outputText
        }
    }
    
    func getNextToken(text:String) -> (token:TokenBase, length:Int) {
        for regex in grammarList {
            if let m = regex.match(text) {
                let name = grammarNameMap[regex]! // Name won't be nil
                let forwardLength = countElements(m.group(0))
                
                let parseFunction = chooseOutputFunctionForGrammar(name)
                let tokenResult = parseFunction(m)
                return (tokenResult, forwardLength)
            }
        }
        return (TokenBase(type: " ", text: text.substringToIndex(advance(text.startIndex, 1))) , 1)
    }

    func outputRefLink(m: RegexMatch) -> TokenBase {
        let key = m.group(2).isEmpty ? m.group(1) : m.group(2)
        if let ret = links[key] {
            return processLink(m, link: ret["link"]!, title: ret["title"]!)
        }
        else {
            return TokenNone()
        }
    }
    
    func processLink(m: RegexMatch, link: String, title: String) -> TokenBase {
        let text = m.group(1)
        return Link(title: title, link: link, text: text)
    }
    
    func outputCode(m: RegexMatch) -> TokenBase {
        return InlineCode(text: m.group(2))
    }
    func outputText(m: RegexMatch) -> TokenBase {
        return TokenBase(type: "text", text: m.group(0))
    }
}

let blockParser = BlockParser()
let inlineParser = InlineParser()

if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
    let dir = dirs[0]
    let path = dir.stringByAppendingPathComponent("test.md")
    if let text = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
        for token in blockParser.parse(text) {
            inlineParser.links = blockParser.definedLinks
            inlineParser.parse(&token.text)
            println(token.render())
        }
    }
}
