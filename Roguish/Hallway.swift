//
//  Hallway.swift
//  Roguish
//
//  Created by Jason Larsen on 12/5/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import Foundation

class Hallway {
    let rects: [Rect]
    
    init(rects: [Rect]) {
        self.rects = rects
    }
    
    func containsPoint(point: Point) -> Bool {
        for rect in rects where rect.containsPoint(point) {
            return true
        }
        return false
    }
    
    static func betweenRooms(first: Room, _ second: Room) -> Hallway {
        let (left, right) = sortByX(first, second)
        let (a, b) = (left.rect, right.rect)
        
        if overlapX(a, b) {
            return betweenOverlappingXRooms(left, right)
        }
        else if overlapY(a, b) {
            return betweenOverlappingYRooms(left, right)
        }
        else if leftIsLower(a, b) {
            return betweenNonOverlappingRoomsWithLeftLower(left: left, right: right)
        }
        else {
            return betweenNonOverlappingRoomsWithRightLower(left: left, right: right)
        }
    }
    
    static func betweenOverlappingXRooms(first: Room, _ second: Room) -> Hallway {
        let height = second.rect.minY - first.rect.maxY
        let width = 1
        let size = Size(width: width, height: height)
        
        var xPrime: Int?
        for x in first.rect.minX...first.rect.maxX where x > second.rect.minX && x < second.rect.maxX {
            xPrime = x
            break
        }
        
        guard let x = xPrime else {
            fatalError("Trying to connect between non overlapping X Rooms")
        }
        
        let origin = Point(x, first.rect.maxY)
        
        let rect = Rect(origin: origin, size: size)
        let hallway = Hallway(rects: [rect])
        return hallway
    }
    
    static func betweenOverlappingYRooms(first: Room, _ second: Room) -> Hallway {
        let width = second.rect.minX - first.rect.maxX
        let height = 1
        var yPrime: Int?
        for y in first.rect.minY...first.rect.maxY where y > second.rect.minY && y < second.rect.maxY {
            yPrime = y
            break
        }
        
        guard let y = yPrime else {
            fatalError("Trying to connect between non overlapping Y Rooms")
        }
        
        let origin = Point(first.rect.maxX, y)
        let size = Size(width: width, height: height)
        let rect = Rect(origin: origin, size: size)
        let hallway = Hallway(rects: [rect])
        return hallway
    }
    
    static func betweenNonOverlappingRoomsWithLeftLower(left left: Room, right: Room) -> Hallway {
        let bottomWallToLeftWall = Bool.random()
        if bottomWallToLeftWall {
            return betweenNonOverlappingRoomsWithLeftLowerFromBottomWallToLeftWall(left: left, right: right)
        }
        else {
            return betweenNonOverlappingRoomsWithLeftLowerFromRightWallToTopWall(left: left, right: right)
        }
    }
    
    static func betweenNonOverlappingRoomsWithLeftLowerFromBottomWallToLeftWall(left left: Room, right: Room) -> Hallway {
        let verticalLeg = Rect(origin: Point(left.rect.midX, left.rect.maxY), size: Size(width: 1, height: right.rect.midY - left.rect.maxY))
        let horizontalLeg = Rect(origin: Point(left.rect.midX, right.rect.midY), size: Size(width: right.rect.minX - left.rect.midX, height: 1))
        return Hallway(rects: [verticalLeg, horizontalLeg])
    }
    
    static func betweenNonOverlappingRoomsWithLeftLowerFromRightWallToTopWall(left left: Room, right: Room) -> Hallway {
        let horizontalLeg = Rect(origin: Point(left.rect.maxX, left.rect.midY), size: Size(width: right.rect.midX - left.rect.maxX, height: 1))
        let verticalLeg = Rect(origin: Point(right.rect.midX, left.rect.midY), size: Size(width: 1, height: right.rect.minY - left.rect.midY))
        return Hallway(rects: [verticalLeg, horizontalLeg])
    }
    
    static func betweenNonOverlappingRoomsWithRightLower(left left: Room, right: Room) -> Hallway {
        let topWallToLeftWall = Bool.random()
        if topWallToLeftWall {
            return betweenNonOverlappingRoomsWithRightLowerFromTopWallToLeftWall(left: left, right: right)
        }
        else {
            return betweenNonOverlappingRoomsWithRightLowerFromRightWallToBottomWall(left: left, right: right)
        }
    }
    
    static func betweenNonOverlappingRoomsWithRightLowerFromTopWallToLeftWall(left left: Room, right: Room) -> Hallway {
        let verticalLeg = Rect(origin: Point(left.rect.midX, right.rect.midY), size: Size(width: 1, height: left.rect.minY - right.rect.midY))
        let horizontalLeg = Rect(origin: Point(left.rect.midX, right.rect.midY), size: Size(width: right.rect.minX - left.rect.midX, height: 1))
        return Hallway(rects: [verticalLeg, horizontalLeg])
    }

    static func betweenNonOverlappingRoomsWithRightLowerFromRightWallToBottomWall(left left: Room, right: Room) -> Hallway {
        let horizontalLeg = Rect(origin: Point(left.rect.maxX, left.rect.midY), size: Size(width: right.rect.midX - left.rect.maxX, height: 1))
        let verticalLeg = Rect(origin: Point(right.rect.midX, right.rect.maxY), size: Size(width: 1, height: left.rect.midY - right.rect.maxY))
        return Hallway(rects: [verticalLeg, horizontalLeg])
    }

    static private func sortByX(first: Room, _ second: Room) -> (Room, Room) {
        if first.rect.origin.x < second.rect.origin.x {
            return (first, second)
        }
        else {
            return (second, first)
        }
    }
    
    //
    // MARK: - Rect Helpers
    //
    
    static func overlapX(a: Rect, _ b: Rect) -> Bool {
        return a.origin.x <= b.origin.x && b.origin.x < a.origin.x + a.size.width
    }
    
    static func overlapY(a: Rect, _ b: Rect) -> Bool {
        return (a.origin.y <= b.origin.y && b.origin.y < a.origin.y + a.size.height) || (b.origin.y <= a.origin.y && a.origin.y < b.origin.y + b.size.height)
    }
    
    static func leftIsLower(a: Rect, _ b: Rect) -> Bool {
        return a.origin.y < b.origin.y
    }
}