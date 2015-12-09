//
//  SceneKitHelpers.swift
//  Roguish
//
//  Created by Jason Larsen on 12/6/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import SceneKit

func * (rotation: SCNVector4, position: SCNVector3) -> SCNVector3 {
    if rotation.w == 0 {
        return position
    }
    
    let gPosition = SCNVector3ToGLKVector3(position)
    let gRotation = GLKMatrix4MakeRotation(rotation.w, rotation.x, rotation.y, rotation.z)
    let r = GLKMatrix4MultiplyVector3(gRotation, gPosition)
    return SCNVector3FromGLKVector3(r)
}

func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3FromGLKVector3(GLKVector3Subtract(SCNVector3ToGLKVector3(lhs), SCNVector3ToGLKVector3(rhs)))
}
