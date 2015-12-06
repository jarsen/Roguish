//
//  Dungeon2DMap.swift
//  Roguish
//
//  Created by Jason Larsen on 11/21/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import Foundation

struct Dungeon2DMap {
    enum Cell : String {
        case Room = " "
        case Wall = "█"
    }
    
    let map: [[Cell]]
    let width: Int
    let height: Int
    
    init(dungeon: DungeonNode, hallways: [Hallway]) {
        let (width, height) = (dungeon.partition.size.width, dungeon.partition.size.height)
        var map = [[Cell]](count: height, repeatedValue: [Cell](count: width, repeatedValue: .Wall))
        for x in 0..<width {
            for y in 0..<height{
                let point = Point(x, y)
                if dungeon.containsPoint(point) {
                    map[x][y] = .Room
                }
                else {
                    for hallway in hallways where hallway.containsPoint(point) {
                        map[x][y] = .Room
                        break
                    }
                }
            }
        }
        self.map = map
        self.width = map.first!.count
        self.height = map.count
    }
    
    func isRoom(x: Int,_ y: Int) -> Bool {
        return map[x][y] == .Room
    }
    
    func hasNorthWall(x: Int,_ y: Int) -> Bool {
        guard x > 0 else {
            return true
        }
        
        return map[x - 1][y] == .Wall
    }
    
    func hasEastWall(x: Int,_ y: Int) -> Bool {
        guard y > 0 else {
            return true
        }
        
        return map[x][y - 1] == .Wall
    }
    
    func hasSouthWall(x: Int,_ y: Int) -> Bool {
        guard x < map.count - 1 else {
            return true
        }
        
        return map[x + 1][y] == .Wall
    }
    
    func hasWestWall(x: Int,_ y: Int) -> Bool {
        guard y < map.first!.count - 1 else {
            return true
        }
        
        return map[x][y + 1] == .Wall
    }
}

extension Dungeon2DMap : CustomStringConvertible {
    var description: String {
        var text = ""
        for row in map {
            var rowText = ""
            for cell in row {
                rowText += cell.rawValue
            }
            text += rowText + "\n"
        }
        return text
    }
}