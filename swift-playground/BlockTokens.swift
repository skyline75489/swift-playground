//
//  Tokens.swift
//  swift-playground
//
//  Created by skyline on 15/1/5.
//  Copyright (c) 2015年 skyline. All rights reserved.
//

import Foundation

class TokenBase {
    var type:String = ""
    var text:String = ""
    init (type:String, text:String) {
        self.type = type
        self.text = text
    }
    func render() -> String {
        return text
    }
}

class TokenNone: TokenBase {
    init() {
        super.init(type:"", text:"")
    }
    override func render() -> String {
        return ""
    }
}

class NewLine: TokenBase {
    init() {
        super.init(type: "newling", text: "")
    }
    
    override func render() -> String {
        return ""
    }
}

class Heading: TokenBase {
    var level:Int = 1
    init (text:String, level:Int) {
        super.init(type: "heading", text: text)
        self.level = level
    }
    override func render() -> String {
        return "<h\(level)>\(text)<h\(level)>"
    }
}

class BlockCode: TokenBase {
    var lang = String()
    init (text:String, lang:String) {
        super.init(type: "code", text: text)
        self.lang = lang
    }
    override func render() -> String {
        if countElements(lang) == 0 {
            return "<pre><code>\(text)\n</code></pre>\n"
        }
        return "<pre><code class=\"lang-\(lang)\">\(text)\n</code></pre>\n"
    }
}

class HRule: TokenBase {
    init() {
        super.init(type: "hrule", text: "")
    }
    override func render() -> String {
        return "<hr>\n"
    }
}

class BlockQuote: TokenBase {
    
}