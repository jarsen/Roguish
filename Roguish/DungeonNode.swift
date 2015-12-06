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
    
    var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    func rooms() -> [Room] {
        if isLeaf {
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
    
    func containsPoint(point: Point) -> Bool {
        if isLeaf {
            if let room = room {
                return room.rect.containsPoint(point)
            }
            else {
                return false
            }
        }
        else {
            let leftBool = left?.containsPoint(point) ?? false
            let rightBool = right?.containsPoint(point) ?? false
            return leftBool || rightBool
        }
    }
    
    func generateHallways() -> [Hallway] {
        guard let left = left, right = right else {
            // the tree should be full. if there aren't left and right, this is a leaf
            return []
        }
        
        var hallways = [Hallway]()
        
        // connect the nodes post-order traversal
        hallways.appendContentsOf(left.generateHallways())
        hallways.appendContentsOf(right.generateHallways())
        
        switch (left.isLeaf, right.isLeaf) {
        case (true, true):
            hallways.append(Hallway.betweenRooms(left.room!, right.room!))
        case (true, false):
            // connect the left room to a room in the right subtree
            break
        case (false, true):
            // connect a room in the left subtree to room on the right
            break
        case (false, false):
            // connect a room in the left subtree to a room on the right
            break
        }
        
        return hallways
    }
}

extension DungeonNode : CustomStringConvertible {
    var description: String {
        if isLeaf {
            return "Room. Parition: \(partition)"
        }
        else {
            return "Partition: \(partition)"
        }
    }
}
