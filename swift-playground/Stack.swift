//
//  Stack.swift
//  swift-playground
//
//  Created by skyline on 15/1/29.
//  Copyright (c) 2015年 skyline. All rights reserved.
//

import Foundation

class Stack<T> {
    var arr:Array<T> = Array<T>()
    var count: Int {
        get {
            return arr.count
        }
    }
    func push(key:T) {
        arr.append(key)
    }
    
    func top() -> T? {
        if (arr.isEmpty) {
            return nil
        }
        return arr.last
    }
    
    func pop() -> T? {
        if (arr.isEmpty) {
            return nil
        }
        return arr.removeLast()
    }
}