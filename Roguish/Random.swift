//
//  Random.swift
//  Roguish
//
//  Created by Jason Larsen on 11/16/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import Foundation

extension Int {
    public static func random (lower lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

extension Bool {
    public static func random() -> Bool {
        return Int.random(lower: 0, upper: 1) == 0
    }
}