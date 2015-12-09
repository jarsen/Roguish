//
//  StartGameViewController.swift
//  Roguish
//
//  Created by Jason Larsen on 12/9/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import UIKit

class StartGameViewController : UIViewController, GameViewControllerDelegate {
    
    @IBAction func didPressStart() {
        startGame(width: 50, height: 50)
    }
    
    func startGame(width width: Int, height: Int) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        vc.delegate = self
        vc.width = width
        vc.height = width
        presentViewController(vc, animated: false, completion: nil)
    }
    
    func didFinishLevel(vc: GameViewController) {
        vc.dismissViewControllerAnimated(false) {
            self.startGame(width: vc.width + 50, height: vc.height + 50)
        }
    }
}