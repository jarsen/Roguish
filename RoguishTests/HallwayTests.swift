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
    
    func testHallwayBetweenOverlappingXRooms() {
        let left = Room(rect: Rect(origin: Point(1,1), size: Size(width:10, height:10)))
        let right = Room(rect: Rect(origin: Point(5, 15), size: Size(width: 10, height: 10)))
        let hallway = Hallway.betweenOverlappingXRooms(left, right)
        let expectedRect = Rect(origin: Point(6, 11), size: Size(width: 1, height: 4))
        XCTAssertEqual(hallway.rects[0], expectedRect)
    }
    
    func testHallwayBetweenOverlappingYRooms() {
        let left = Room(rect: Rect(origin: Point(1,10), size: Size(width:10, height:10)))
        
        let rightLower = Room(rect: Rect(origin: Point(15, 7), size: Size(width: 5, height: 5)))
        let expectedRightLowerRect = Rect(origin: Point(11, 10), size: Size(width: 4, height: 1))
        let lowerHallway = Hallway.betweenOverlappingYRooms(left, rightLower)
        XCTAssertEqual(lowerHallway.rects[0], expectedRightLowerRect)
        
        let rightUpper = Room(rect: Rect(origin: Point(15, 17), size: Size(width: 5, height: 5)))
        let expectedRightUpperRect = Rect(origin: Point(11, 18), size: Size(width: 4, height: 1))
        let upperHallway = Hallway.betweenOverlappingYRooms(left, rightUpper)
        XCTAssertEqual(upperHallway.rects[0], expectedRightUpperRect)
    }
    
    func testHallwayBetweenNonOverlappingRoomsWithLeftLowerFromBottomWallToLeftWall() {
        let left = Room(rect: Rect(origin: Point(0,0), size: Size(width:10, height:10)))
        let right = Room(rect: Rect(origin: Point(15, 15), size: Size(width: 10, height: 10)))
        let hallway = Hallway.betweenNonOverlappingRoomsWithLeftLowerFromBottomWallToLeftWall(left: left, right: right)
        let expectedRect0 = Rect(origin: Point(5, 10), size: Size(width: 1, height: 10))
        let expectedRect1 = Rect(origin: Point(5, 20), size: Size(width: 10, height: 1))
        XCTAssertEqual(hallway.rects[0], expectedRect0)
        XCTAssertEqual(hallway.rects[1], expectedRect1)
    }
    
    func testHallwayBetweenNonOverlappingRoomsWithLeftLowerFromRightWallToTopWall() {
        let left = Room(rect: Rect(origin: Point(0,0), size: Size(width:10, height:10)))
        let right = Room(rect: Rect(origin: Point(15, 15), size: Size(width: 10, height: 10)))
        let hallway = Hallway.betweenNonOverlappingRoomsWithLeftLowerFromRightWallToTopWall(left: left, right: right)
        let expectedRect0 = Rect(origin: Point(20, 5), size: Size(width: 1, height: 10))
        let expectedRect1 = Rect(origin: Point(10, 5), size: Size(width: 10, height: 1))
        XCTAssertEqual(hallway.rects[0], expectedRect0)
        XCTAssertEqual(hallway.rects[1], expectedRect1)
    }
    
    func testHallwayBetweenNonOverlappingRoomsWithRightLowerFromTopWallToLeftWall() {
        let left = Room(rect: Rect(origin: Point(0,15), size: Size(width:10, height:10)))
        let right = Room(rect: Rect(origin: Point(15, 0), size: Size(width: 10, height: 10)))
        let hallway = Hallway.betweenNonOverlappingRoomsWithRightLowerFromTopWallToLeftWall(left: left, right: right)
        let expectedRect0 = Rect(origin: Point(5, 5), size: Size(width: 1, height: 10))
        let expectedRect1 = Rect(origin: Point(5, 5), size: Size(width: 10, height: 1))
        XCTAssertEqual(hallway.rects[0], expectedRect0)
        XCTAssertEqual(hallway.rects[1], expectedRect1)
    }
    
    func testHallwayBetweenNonOverlappingRoomsWithRightLowerFromRightWallToBottomWall() {
        let left = Room(rect: Rect(origin: Point(0,15), size: Size(width:10, height:10)))
        let right = Room(rect: Rect(origin: Point(15, 0), size: Size(width: 10, height: 10)))
        let hallway = Hallway.betweenNonOverlappingRoomsWithRightLowerFromRightWallToBottomWall(left: left, right: right)
        let expectedRect0 = Rect(origin: Point(20, 10), size: Size(width: 1, height: 10))
        let expectedRect1 = Rect(origin: Point(10, 20), size: Size(width: 10, height: 1))
        XCTAssertEqual(hallway.rects[0], expectedRect0)
        XCTAssertEqual(hallway.rects[1], expectedRect1)
    }
}