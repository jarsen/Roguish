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
import GameController

extension SCNLight {
    convenience init(type: String, color lightColor: UIColor? = nil) {
        self.init()
        self.type = type
        if let lightColor = lightColor {
            self.color = lightColor
        }
    }
}

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    var sceneView: SCNView {
        return view as! SCNView
    }
    
    var scene: SCNScene!
    var cameraNode: SCNNode!
    
    var controller: GCController?
    
    var map: Dungeon2DMap! {
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
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight(type: SCNLightTypeOmni)
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight(type: SCNLightTypeAmbient, color: .darkGrayColor())
        scene.rootNode.addChildNode(ambientLightNode)
        
        map = generateMap()
        guard let map = map else { fatalError() }
        
        // place the camera
        cameraNode.position = SCNVector3(x: Float(map.startPoint.x), y: 1, z: Float(map.startPoint.y))

        // set the scene to the view
        sceneView.scene = scene
        sceneView.delegate = self
        
        // allows the user to manipulate the camera
//        sceneView.allowsCameraControl = true
        sceneView.playing = true
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // configure the view
        sceneView.backgroundColor = .blackColor()
        
        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
//        sceneView.addGestureRecognizer(tapGesture)
    }
    
    func generateMap() -> Dungeon2DMap {
        let mapRect = Rect(origin: Point(0,0), size: Size(width: 50, height: 50))
        let root = DungeonNode(partition: mapRect)
        let hallways = root.generateHallways()
        let map = Dungeon2DMap(dungeon: root, hallways: hallways)
        print(map)
        return map
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
        let z = map.height - 1 - y
        let floor = SCNBox(width: 1, height: 0, length: 1, chamferRadius: 0)
        floor.materials.first!.diffuse.contents = map.map[x][y].tileAsset
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3Make(Float(x), 0, Float(z))
        scene.rootNode.addChildNode(floorNode)
    }
    
    func addNorthWall(x: Int, _ y: Int) {
        let z = map.height - 1 - y
        let wall = SCNBox(width: 0, height: 1, length: 1, chamferRadius: 0)
        wall.materials.first!.diffuse.contents = UIImage(named: "cobblestone")
        let wallNode = SCNNode(geometry: wall)
        wallNode.position = SCNVector3Make(Float(x) - 0.5, 0.5, Float(z))
        scene.rootNode.addChildNode(wallNode)
        wallNode.rotation = SCNVector4Make(0, Float(M_PI_2), 0, 0)
    }
    
    func addEastWall(x: Int, _ y: Int) {
        let z = map.height - 1 - y
        let wall = SCNBox(width: 1, height: 1, length: 0, chamferRadius: 0)
        wall.materials.first!.diffuse.contents = UIImage(named: "cobblestone")
        let wallNode = SCNNode(geometry: wall)
        wallNode.position = SCNVector3Make(Float(x), 0.5, Float(z) + 0.5)
        scene.rootNode.addChildNode(wallNode)
    }
    
    func addSouthWall(x: Int, _ y: Int) {
        let z = map.height - 1 - y
        let wall = SCNBox(width: 0, height: 1, length: 1, chamferRadius: 0)
        wall.materials.first!.diffuse.contents = UIImage(named: "cobblestone")
        let wallNode = SCNNode(geometry: wall)
        wallNode.position = SCNVector3Make(Float(x) + 0.5, 0.5, Float(z))
        scene.rootNode.addChildNode(wallNode)
        wallNode.rotation = SCNVector4Make(0, Float(M_PI_2), 0, 0)
    }
    
    func addWestWall(x: Int, _ y: Int) {
        let z = map.height - 1 - y
        let wall = SCNBox(width: 1, height: 1, length: 0, chamferRadius: 0)
        wall.materials.first!.diffuse.contents = UIImage(named: "cobblestone")
        let wallNode = SCNNode(geometry: wall)
        wallNode.position = SCNVector3Make(Float(x), 0.5, Float(z) - 0.5)
        scene.rootNode.addChildNode(wallNode)
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

    //
    // MARK: - Game Loop
    //
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        readControlInputs()
    }
    
    //
    // MARK: - Controls
    //
    
    func readControlInputs() {
        guard let gamepad = GCController.controllers().first?.extendedGamepad else { return }
        
        let leftRightRotation = CGFloat(gamepad.leftThumbstick.xAxis.value) * -0.1
        let upDownRotation = CGFloat(gamepad.leftThumbstick.yAxis.value) * 0.1
        let rotationAction = SCNAction.rotateByX(upDownRotation, y: leftRightRotation, z: 0, duration: 0.1)
        
        let leftRightMovement = gamepad.rightThumbstick.xAxis.value * 0.1
        let forwardBackMovement = gamepad.rightThumbstick.yAxis.value * -0.1
        var movement = cameraNode.rotation * SCNVector3(x: leftRightMovement, y: 0, z: forwardBackMovement)
        movement.y = 0
        let movementAction = SCNAction.moveBy(movement, duration: 0.1)
        
        let action = SCNAction.group([rotationAction, movementAction])
        cameraNode.runAction(action)
    }
    
    //
    // MARK: - View Rotation
    //
    
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
