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
        let (a, b) = sortByX(first.rect, second.rect)
        
        if overlapX(a, b) {
            return betweenOverlappingXRooms(first, second)
        }
        else if overlapY(a, b) {
            return betweenOverlappingYRooms(first, second)
        }
        else if leftIsLower(a, b) {
            return betweenNonOverlappingRoomsWithLeftLower(left: first, right: second)
        }
        else {
            return betweenNonOverlappingRoomsWithRightLower(left: first, right: second)
        }
    }
    
    static func betweenOverlappingXRooms(first: Room, _ second: Room) -> Hallway {
        let y1 = first.rect.minY
        let y2 = second.rect.minY
        let height = y2 - y1
        let width = 1
        var xPrime: Int?
        for x in first.rect.minX...first.rect.maxX where x > second.rect.minX && x < second.rect.maxX {
            xPrime = x
            break
        }
        
        guard let x = xPrime else {
            fatalError("Trying to connect between non overlapping X Rooms")
        }
        
        let origin = Point(x, y1)
        let size = Size(width: width, height: height)
        let rect = Rect(origin: origin, size: size)
        let hallway = Hallway(rects: [rect])
        return hallway
    }
    
    static func betweenOverlappingYRooms(first: Room, _ second: Room) -> Hallway {
        let x1 = first.rect.minX
        let x2 = second.rect.minX
        let width = x2 - x1
        let height = 1
        var yPrime: Int?
        for y in first.rect.minY...first.rect.maxY where y > second.rect.minY && y < second.rect.maxY {
            yPrime = y
            break
        }
        
        guard let y = yPrime else {
            fatalError("Trying to connect between non overlapping Y Rooms")
        }
        
        let origin = Point(x1, y)
        let size = Size(width: width, height: height)
        let rect = Rect(origin: origin, size: size)
        let hallway = Hallway(rects: [rect])
        return hallway
    }
    
    static func betweenNonOverlappingRoomsWithLeftLower(left left: Room, right: Room) -> Hallway {
        return Hallway(rects: [Rect(origin: Point(0,0), size: Size(width: 0, height: 0))])
    }
    
    static func betweenNonOverlappingRoomsWithRightLower(left left: Room, right: Room) -> Hallway {
        return Hallway(rects: [Rect(origin: Point(0,0), size: Size(width: 0, height: 0))])
    }
    
    static private func sortByX(first: Rect, _ second: Rect) -> (Rect, Rect) {
        if first.origin.x < second.origin.x {
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
        return a.origin.y <= b.origin.y && b.origin.y < a.origin.y + a.size.height
    }
    
    static func leftIsLower(a: Rect, _ b: Rect) -> Bool {
        return a.origin.y < b.origin.y
    }
}