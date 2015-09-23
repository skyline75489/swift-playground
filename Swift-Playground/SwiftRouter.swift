//
//  SwiftRouter.swift
//  Swift-Playground
//
//  Created by skyline on 15/9/23.
//  Copyright © 2015年 skyline. All rights reserved.
//

import Foundation

class RouteEntry {
    var pattern: String? = nil
    var handler: (([String:String]?) -> Bool)? = nil
    var klass: AnyClass? = nil
    
    init(pattern:String?, cls: AnyClass?=nil, handler:((params: [String:String]?) -> Bool)?=nil) {
        self.pattern = pattern
        self.klass = cls
        self.handler = handler
    }
}

class SwiftRouter {
    static let sharedInstance = SwiftRouter()
    private var routeMap = [String:RouteEntry]()
    
    
    func map(route: String, controllerClass: AnyClass) -> Void {
        self.doMap(route, cls: controllerClass)
    }
    
    func map(route: String, handler:([String:String]?) -> (Bool)) -> Void {
        self.doMap(route, handler: handler)
    }
    
    func doMap(route: String, cls: AnyClass?=nil, handler:(([String:String]?) -> (Bool))?=nil) -> Void {
        guard self.routeMap[route] == nil else {
            return
        }
        if let k = cls {
            let r = RouteEntry(pattern: route, cls: k)
            self.routeMap[route] = r
        } else {
            let r = RouteEntry(pattern: route, handler: handler)
            self.routeMap[route] = r
        }
    }
    
    func matchController(route: String) -> AnyClass? {
        if let o = self.routeMap[route] {
            return o.klass
        }
        return nil
    }
    
    func matchHandler(route: String) -> (([String:String]?) -> (Bool))? {
        if let h = self.routeMap[route] {
            return h.handler
        }
        return nil
    }
}
