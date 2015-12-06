//
//  HallwayTests.swift
//  Roguish
//
//  Created by Jason Larsen on 12/5/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import XCTest
@testable import Roguish

class HallwayTests : XCTestCase {
    func testValidOverlapX() {
        let rect1 = Rect(origin: Point(1,1), size: Size(width: 10, height: 1))
        let rect2 = Rect(origin: Point(5,5), size: Size(width: 10, height: 1))
        XCTAssertTrue(Hallway.overlapX(rect1, rect2))
    }
    
    func testInvalidOverlapX() {
        let rect1 = Rect(origin: Point(1,1), size: Size(width: 10, height: 1))
        let rect2 = Rect(origin: Point(12,5), size: Size(width: 10, height: 1))
        XCTAssertFalse(Hallway.overlapX(rect1, rect2))
    }
    
    func testValidOverlapY() {
        let rect1 = Rect(origin: Point(1,1), size: Size(width: 4, height: 10))
        let rect2 = Rect(origin: Point(10,5), size: Size(width: 4, height: 10))
        XCTAssertTrue(Hallway.overlapY(rect1, rect2))
    }
    
    func testInvalidOverlapY() {
        let rect1 = Rect(origin: Point(1,1), size: Size(width: 4, height: 10))
        let rect2 = Rect(origin: Point(6,12), size: Size(width: 4, height: 10))
        XCTAssertFalse(Hallway.overlapY(rect1, rect2))
    }
}