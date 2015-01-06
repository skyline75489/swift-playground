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
    var _pattern:String
    var _matches:RegexMatch?
    var _error:NSError?
    
    init(pattern:String) {
        _pattern = pattern
        _re = NSRegularExpression(pattern: _pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &_error)
    }
    
    func match(str:String) -> RegexMatch? {
        if let re = _re {
            _matches = RegexMatch(str:str, matches: re.matchesInString(str, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, countElements(str))))
            if _matches?.count > 0 {
                return _matches
            }
            else {
                return nil
            }
        }
        return nil
    }
}

class RegexMatch  {
    private var _m:[AnyObject]?
    var matchedString = [String]()
    var _str:String // String to match against
    var count:Int = 0
    var start:String.Index = String().startIndex
    var end:String.Index = String().endIndex
    
    init(str:String, matches:[AnyObject]?) {
        _str = str
        if let _matches = matches {
            _m = _matches
            count = _matches.count
            let matches = _m as [NSTextCheckingResult]
            // We assume there is only one match(the first match)
            for match in matches  {
                count = match.numberOfRanges
                for i in 0..<match.numberOfRanges {
                    let range = match.rangeAtIndex(i)
                    start = advance(_str.startIndex, range.location)
                    end = advance(start, range.length)
                    let r = _str.substringWithRange(Range<String.Index>(start: start, end: end))
                    matchedString.append(r)
                }
            }
        }
    }
    
    func range() -> Range<String.Index> {
        return Range<String.Index>(start: self.start, end: self.end)
    }
    
    func group(index:Int) -> String {
        // Index out of bound
        if index > count + 1 {
            return ""
        }
        return matchedString[index]
    }
}