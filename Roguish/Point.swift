//
//  Point.swift
//  Roguish
//
//  Created by Jason Larsen on 11/16/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import Foundation

struct Point {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

extension Point : CustomStringConvertible {
    var description: String {
        return "(\(x), \(y))"
    }
}