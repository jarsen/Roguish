//
//  DungeonNode.swift
//  Roguish
//
//  Created by Jason Larsen on 11/16/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import Foundation

let MIN_ROOM_WIDTH = 5
let MIN_ROOM_HEIGHT = 5

class DungeonNode {
    var partition: Rect
    var room: Room? // only has a room if this is a leaf node
    var left: DungeonNode?
    var right: DungeonNode?
    
    init(partition: Rect) {
        self.partition = partition
        
        let probability = partition.probabilityOfBinaryPartition()
        let actual = Double(Int.random(lower: 0, upper: 100)) / 100
        if actual < probability {
            if let (l, r) = subdivide() {
                left = l
                right = r
            }
            else {
                initializeRoom()
            }
        }
        else {
            initializeRoom()
        }
    }
    
    func initializeRoom() {
        let rect = partition.randomInnerRect(MIN_ROOM_WIDTH, minHeight: MIN_ROOM_HEIGHT)
        room = rect.map { Room(rect: $0) }
    }
    
    func subdivide() -> (DungeonNode, DungeonNode)? {
        if let (leftRect, rightRect) = partition.binaryPartition(minWidth: MIN_ROOM_WIDTH, minHeight: MIN_ROOM_HEIGHT) {
            return (DungeonNode(partition: leftRect), DungeonNode(partition: rightRect))
        }
        return nil
    }
    
    func isLeaf() -> Bool {
        return left == nil && right == nil
    }
    
    func rooms() -> [Room] {
        if isLeaf() {
            if let room = room {
                return [room]
            }
            else {
                return []
            }
        }
        else {
            var rooms = [Room]()
            let leftRooms = left?.rooms() ?? []
            let rightRooms = right?.rooms() ?? []
            rooms.appendContentsOf(leftRooms)
            rooms.appendContentsOf(rightRooms)
            return rooms
        }
    }
    
    func pointIsInRoom(point: Point) -> Bool {
        if isLeaf() {
            if let room = room {
                return room.rect.containsPoint(point)
            }
            else {
                return false
            }
        }
        else {
            let leftBool = left?.pointIsInRoom(point) ?? false
            let rightBool = right?.pointIsInRoom(point) ?? false
            return leftBool || rightBool
        }
    }
}

extension DungeonNode : CustomStringConvertible {
    var description: String {
        if isLeaf() {
            return "Room. Parition: \(partition)"
        }
        else {
            return "Partition: \(partition)"
        }
    }
}

func printRooms(root: DungeonNode) {
    let (width, height) = (root.partition.size.width, root.partition.size.height)
    for x in 0..<width {
        var row = ""
        for y in 0..<height{
            if root.pointIsInRoom(Point(x, y)) {
                row += " "
            }
            else {
                row += "█"
            }
        }
        print(row)
    }
}
