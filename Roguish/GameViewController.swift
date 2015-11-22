//
//  GameViewController.swift
//  Roguish
//
//  Created by Jason Larsen on 11/16/15.
//  Copyright (c) 2015 Jason Larsen. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

extension SCNLight {
    convenience init(type: String, color lightColor: UIColor? = nil) {
        self.init()
        self.type = type
        if let lightColor = lightColor {
            self.color = lightColor
        }
    }
}

class GameViewController: UIViewController {
    var sceneView: SCNView {
        return view as! SCNView
    }
    
    var scene: SCNScene!
    
    var map: Dungeon2DMap? {
        didSet {
            if let map = map {
                init3DMapRepresentation(map)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene()
        scene.rootNode.rotation = SCNVector4Make(0, Float(M_PI), 0, 1)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight(type: SCNLightTypeOmni)
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight(type: SCNLightTypeAmbient, color: .darkGrayColor())
        scene.rootNode.addChildNode(ambientLightNode)
        
        generateMap()
        
//        let westWall = SCNBox(width: 0, height: 1, length: 1, chamferRadius: 0)
//        westWall.materials.first!.diffuse.contents = UIImage(named: "cobblestone")
//        let westWallNode = SCNNode(geometry: westWall)
//        westWallNode.position = SCNVector3Make(-0.5, 0.5, 0)
//        scene.rootNode.addChildNode(westWallNode)
//        
//        let floor = SCNBox(width: 1, height: 0, length: 1, chamferRadius: 0)
//        floor.materials.first!.diffuse.contents = UIImage(named: "sandstone")
//        let floorNode = SCNNode(geometry: floor)
//        scene.rootNode.addChildNode(floorNode)
        
        // set the scene to the view
        sceneView.scene = scene
        
        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // configure the view
        sceneView.backgroundColor = .blackColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    func generateMap() {
        let mapRect = Rect(origin: Point(0,0), size: Size(width: 50, height: 50))
        let root = DungeonNode(partition: mapRect)
        map = Dungeon2DMap(dungeon: root)
    }
    
    func init3DMapRepresentation(map: Dungeon2DMap) {
        for x in 0..<map.width {
            for y in 0..<map.height {
                if map.isRoom(x, y) {
                    addFloor(x, y)
                    if map.hasNorthWall(x, y) {
                        addNorthWall(x, y)
                    }
                    if map.hasEastWall(x, y) {
                        addEastWall(x, y)
                    }
                    if map.hasSouthWall(x, y) {
                        addSouthWall(x, y)
                    }
                    if map.hasWestWall(x, y) {
                        addWestWall(x, y)
                    }
                }
            }
        }
    }
    
    func addFloor(x: Int, _ y: Int) {
        let floor = SCNBox(width: 1, height: 0, length: 1, chamferRadius: 0)
        floor.materials.first!.diffuse.contents = UIImage(named: "sandstone")
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3Make(Float(x), 0, Float(y))
        scene.rootNode.addChildNode(floorNode)
    }
    
    func addNorthWall(x: Int, _ y: Int) {
        
    }
    
    func addEastWall(x: Int, _ y: Int) {
        
    }
    
    func addSouthWall(x: Int, _ y: Int) {
        
    }
    
    func addWestWall(x: Int, _ y: Int) {
        
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at lwest one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            guard let result = hitResults.first,
                material = result.node.geometry?.firstMaterial else {
                    return
            }
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

}
