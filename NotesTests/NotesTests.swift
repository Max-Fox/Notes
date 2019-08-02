//
//  NotesTests.swift
//  NotesTests
//
//  Created by Максим Лисица on 06/07/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import XCTest
@testable import Notes


class NotesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEqualUUID() {
        let test1 = Note(title: "test", content: "testq", priority: .important, dateDead: nil)
        let test2 = Note(title: "test", content: "testq", priority: .important, dateDead: nil)
        
        XCTAssertNotEqual(test1.uid, test2.uid)
    }
}
