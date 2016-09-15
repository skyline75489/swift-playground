import XCTest
@testable import swift_playground

class swift_playgroundTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(swift_playground().text, "Hello, World!")
    }


    static var allTests : [(String, (swift_playgroundTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
