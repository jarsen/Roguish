//
//  Size.swift
//  Roguish
//
//  Created by Jason Larsen on 11/16/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import Foundation

struct Size {
    var width: Int
    var height: Int
    
    var area: Int {
        return width * height
    }
}

extension Size : CustomStringConvertible {
    var description: String {
        return "\(width)x\(height)"
    }
}

extension Size : Equatable {
    
}

func == (lhs: Size, rhs: Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}