//
//  Swift_PlaygroundTests.swift
//  Swift-PlaygroundTests
//
//  Created by skyline on 15/9/22.
//  Copyright © 2015年 skyline. All rights reserved.
//

import XCTest

@testable import Swift_Playground

class Swift_PlaygroundTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRouteController() {
        let router = SwiftRouter.sharedInstance
        router.map("/user/:userId", controllerClass: UserViewController.self)
        router.map("/story/:storyId", controllerClass: StoryViewController.self)
        router.map("/user/:userId/story", controllerClass: StoryListViewController.self)

        XCTAssertTrue(router.matchController("/user/1")!.isKindOfClass( UserViewController.self))
        XCTAssertTrue(router.matchController("/story/2")!.isKindOfClass( StoryViewController.self))
        XCTAssertTrue(router.matchController("/user/2/story")!.isKindOfClass( StoryListViewController.self))
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
