//
//  Rect.swift
//  Roguish
//
//  Created by Jason Larsen on 11/16/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import Foundation


struct Rect {
    var origin: Point
    var size: Size
    
    init(origin: Point, size: Size) {
        guard size.width >= 0 && size.height >= 0 else {
            fatalError()
        }
        self.origin = origin
        self.size = size
    }
    
    var minX: Int {
        return origin.x
    }
    
    var maxX: Int {
        return origin.x + size.width
    }
    
    var midX: Int {
        return (maxX + minX) / 2
    }
    
    var minY: Int {
        return origin.y
    }
    
    var maxY: Int {
        return origin.y + size.height
    }
    
    var midY: Int {
        return (maxY + minY) / 2
    }
    
    func intersects(rect: Rect) -> Bool {
        return minX < rect.maxX && maxX > rect.minX && minY < rect.maxY && maxY > rect.minY
    }
}

extension Rect {
    func probabilityOfBinaryPartition() -> Double {
        let area = Double(size.area)
        switch area {
        case 100...Double.infinity: // nothing over area 100
            return 1
        default:
            return min(1, (1 / 100) * area)
        }
    }
    
    func binaryPartition(minWidth minWidth: Int, minHeight: Int) -> (Rect, Rect)? {
        guard size.width > minWidth && size.height > minHeight else {
            return nil
        }
        
        let verticalPartition = Bool.random()
        let scale = Int.random(lower: 20, upper: 80)
        
        if verticalPartition {
            let heightA = (size.height * scale) / 100
            let heightB = size.height - heightA
            
            guard heightA > minHeight && heightB > minHeight else {
                return nil
            }
            
            let rectA = Rect(origin: Point(origin.x, origin.y), size: Size(width: size.width, height: heightA))
            let rectB = Rect(origin: Point(origin.x, origin.y + heightA), size: Size(width: size.width, height: heightB))
            
            return (rectA, rectB)
        }
        else { // horizontal partition
            let widthA = (size.width * scale) / 100
            let widthB = size.width - widthA
            
            guard widthA > minWidth && widthB > minWidth else {
                return nil
            }
            
            let rectA = Rect(origin: Point(origin.x, origin.y), size: Size(width: widthA, height: size.height))
            let rectB = Rect(origin: Point(origin.x + widthA, origin.y), size: Size(width: widthB, height: size.height))
            
            return (rectA, rectB)
        }
        
    }
    
    func containsPoint(point: Point) -> Bool {
        let containsX = origin.x <= point.x && point.x < origin.x + size.width
        let containsY = origin.y <= point.y && point.y < origin.y + size.height
        return containsX && containsY
    }
    
    func randomInnerRect(minWidth: Int, minHeight: Int) -> Rect? {
        guard size.width > minWidth && size.height > minHeight else {
            return nil
        }
        
        
        // pick a random width and height
        let width = Int.random(lower: minWidth - 4, upper: size.width)
        let height = Int.random(lower: minHeight - 4, upper: size.height)
        
        // pick a random x and y
        let x = Int.random(lower: origin.x, upper: origin.x + size.width - width) + 2
        let y = Int.random(lower: origin.y, upper: origin.y + size.height - height) + 2
        
        return Rect(origin: Point(x, y), size: Size(width: width, height: height))
    }
    
    func randomInnerPoint() -> Point {
        let x = Int.random(lower: minX + 1, upper: maxX - 2)
        let y = Int.random(lower: minY + 1, upper: maxY - 2)
        return Point(x, y)
    }
}

extension Rect : CustomStringConvertible {
    var description: String {
        return "\(size) at \(origin)"
    }
}

extension Rect : Equatable { }

func == (lhs: Rect, rhs: Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
}