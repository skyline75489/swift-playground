//
//  Regex.swift
//  swift-playground
//
//  Created by skyline on 15/1/5.
//  Copyright (c) 2015年 skyline. All rights reserved.
//

import Foundation

class Regex {
    var _re:NSRegularExpression?
    var _pattern:String {
        willSet {
            _re = NSRegularExpression(pattern: _pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
        }
    }
    var _matches:Matches?
    
    init(pattern:String) {
        _pattern = pattern
        _re = NSRegularExpression(pattern: _pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    }
    
    func match(str:String) -> Matches? {
        if let re = _re {
            _matches = Matches(str:str, matches: re.matchesInString(str, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, countElements(str))))
            return _matches
        }
        return nil
    }
}

class Matches  {
    var _m:[AnyObject]?
    var _str:String // String to match against
    var count:Int = 0
    
    init(str:String, matches:[AnyObject]?) {
        _str = str
        if let _matches = matches {
            _m = _matches
            count = _matches.count
        }
    }
    func group(index:Int) -> String? {
        // Index out of bound
        if index > count + 1 {
            return nil
        }
        let matches = _m as [NSTextCheckingResult]
        for match in matches  {
            let range = match.rangeAtIndex(index)
            let start = advance(_str.startIndex, range.location)
            let end = advance(start, range.length)
            let r = _str.substringWithRange(Range<String.Index>(start: start, end: end))
            return r
        }
        return nil
    }
}