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
    private var routeMap = [String:AnyObject]()
    
    
    func map(route: String, controllerClass: AnyClass) {
        self.doMap(route, cls: controllerClass)
    }
    
    func map(route: String, handler:([String:String]?) -> (Bool)) {
        let pathComponents = self.pathComponentsInRoute(route)
        let _route = pathComponents.joinWithSeparator("")
        self.doMap(_route, handler: handler)
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
        for pathComponent in pathComponents {
            let r = self.insertRoute(pathComponent, pathComponents: pathComponents, entry: r, subRoutes: &self.routeMap)
            if r == nil {
                break
            }
        }
    }
    
    func insertRoute(pathComponent: String, pathComponents: [String], entry: RouteEntry, inout subRoutes: [String:AnyObject]) -> [String:AnyObject]?{
        if subRoutes[pathComponent] == nil {
            if pathComponent == pathComponents.last {
                subRoutes[pathComponent] = entry
                return nil
            }
            subRoutes[pathComponent] = [String: AnyObject]()
        }
        return subRoutes[pathComponent] as! [String: AnyObject]
    }
    
    func matchController(route: String) -> AnyClass? {
        if let entry = self.findRouteEntry(route) {
            return entry.klass
        }
        return nil;
    }
    
    func matchHandler(route: String) -> (([String:String]?) -> (Bool))? {
        if let entry = self.findRouteEntry(route) {
            return entry.handler
        }
        return nil
    }
    
    func findRouteEntry(route: String) -> RouteEntry? {
        let pathComponents = self.pathComponentsInRoute(route)
        
        var subRoutes = self.routeMap
        for pathComponent in pathComponents {
            if subRoutes[pathComponent] != nil {
                if pathComponent == pathComponents.last {
                    let entry = subRoutes[pathComponent] as! RouteEntry
                    return entry
                }
                subRoutes = subRoutes[pathComponent] as! [String: AnyObject]
            }
        }
        return nil
    }
    
    func paramsInRoute(route: String) -> [String: String]? {

        var params = [String:String]()
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
