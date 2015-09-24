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
    private var routeMap = NSMutableDictionary()
    
    
    func map(route: String, controllerClass: AnyClass) {
        self.doMap(route, cls: controllerClass)
    }
    
    func map(route: String, handler:([String:String]?) -> (Bool)) {
        self.doMap(route, handler: handler)
    }
    
    func doMap(route: String, cls: AnyClass?=nil, handler:(([String:String]?) -> (Bool))?=nil) -> Void {
        guard self.routeMap[route] == nil else {
            return
        }
        var r = RouteEntry(pattern: "/", cls: nil)
        if let k = cls {
            r = RouteEntry(pattern: route, cls: k)
        } else {
            r = RouteEntry(pattern: route, handler: handler)
        }
        let pathComponents = self.pathComponentsInRoute(route)
        self.insertRoute(pathComponents, entry: r, subRoutes: self.routeMap)
    }

    func insertRoute(pathComponents: [String], entry: RouteEntry, subRoutes: NSMutableDictionary, startIndex: Int = 0){
    
        let pathComponent = pathComponents[startIndex]
        if subRoutes[pathComponent] == nil {
            if pathComponent == pathComponents.last {
                subRoutes[pathComponent] = entry
                return
            }
            subRoutes[pathComponent] = NSMutableDictionary()
        }
        self.insertRoute(pathComponents, entry: entry, subRoutes: subRoutes[pathComponent] as! NSMutableDictionary, startIndex: startIndex+1)
    }
    
    func matchController(route: String) -> AnyClass? {
        var a = [String:String]()
        if let entry = self.findRouteEntry(route, params: &a) {
            return entry.klass
        }
        return nil;
    }
    
    func matchHandler(route: String) -> (([String:String]?) -> (Bool))? {
        var a = [String:String]()
        if let entry = self.findRouteEntry(route, params: &a) {
            return entry.handler
        }
        return nil
    }
    
    func findRouteEntry(route: String, inout params:[String:String]) -> RouteEntry? {
        let pathComponents = self.pathComponentsInRoute(route)
        
        var subRoutes = self.routeMap
        for pathComponent in pathComponents {
            for (k, v) in subRoutes {
                if k.hasPrefix(":") {
                    let s = String(k)
                    let key = s.substringFromIndex(s.startIndex.advancedBy(1))
                    params[key] = pathComponent
                    if pathComponent == pathComponents.last {
                        return v as? RouteEntry
                    }
                    subRoutes = subRoutes[s] as! NSMutableDictionary
                    break
                }
                if subRoutes[pathComponent] != nil {
                    if pathComponent == pathComponents.last {
                        let entry = subRoutes[pathComponent] as! RouteEntry
                        return entry
                    }
                    subRoutes = subRoutes[pathComponent] as! NSMutableDictionary
                    break
                }
            }
        }
        return nil
    }
    
    func paramsInRoute(route: String) -> [String: String]? {

        var params = [String:String]()
        self.findRouteEntry(route, params: &params)
        
        if  let loc = route.rangeOfString("?") {
            let paramsString = route.substringFromIndex(loc.startIndex.advancedBy(1))
            let paramArray = paramsString.componentsSeparatedByString("&")
            for param in paramArray {
                let kv = param.componentsSeparatedByString("=")
                let k = kv[0]
                let v = kv[1]
                params[k] = v
            }
        }
        if params.isEmpty {
            return nil
        }
        return params
    }
    
    func pathComponentsInRoute(route: String) -> [String] {
        var path:NSString = NSString(string: route)
        if  let loc = route.rangeOfString("?") {
            path = NSString(string: route.substringToIndex(loc.startIndex))
        }
        var result = [String]()
        for pathComponent in path.pathComponents {
            if pathComponent == "/" {
                continue
            }
            result.append(pathComponent)
        }
        return result
    }
    
    func routeURL(route:String) {
        if let handler = self.matchHandler(route) {
            let params = self.paramsInRoute(route)
            handler(params)
        }
    }
}
