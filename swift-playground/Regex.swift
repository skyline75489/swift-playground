//
//  Regex.swift
//  swift-playground
//
//  Created by skyline on 15/1/5.
//  Copyright (c) 2015年 skyline. All rights reserved.
//

import Foundation

class Regex {
    private var _re:NSRegularExpression?
    private var _pattern:String
    var _matches:RegexMatch?
    var _error:NSError?
    
    init(pattern:String) {
        _pattern = pattern
        _re = NSRegularExpression(pattern: _pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &_error)
    }
    
    func match(str:String) -> RegexMatch? {
        if let re = _re {
            _matches = RegexMatch(str:str, matches: re.matchesInString(str, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, countElements(str))))
            return _matches
        }
        return nil
    }
}

class RegexMatch  {
    private var _m:[AnyObject]?
    private var matchedStriing = [String]()
    var _str:String // String to match against
    var count:Int = 0
    
    init(str:String, matches:[AnyObject]?) {
        _str = str
        if let _matches = matches {
            _m = _matches
            count = _matches.count
            let matches = _m as [NSTextCheckingResult]
            for match in matches  {
                for i in 0..<match.numberOfRanges {
                    let range = match.rangeAtIndex(i)
                    let start = advance(_str.startIndex, range.location)
                    let end = advance(start, range.length)
                    let r = _str.substringWithRange(Range<String.Index>(start: start, end: end))
                    matchedStriing.append(r)
                }
            }
        }
    }
    func group(index:Int) -> String? {
        // Index out of bound
        if index > count + 1 {
            return nil
        }
        return matchedStriing[index]
    }
}