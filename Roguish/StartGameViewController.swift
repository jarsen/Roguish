//
//  StartGameViewController.swift
//  Roguish
//
//  Created by Jason Larsen on 12/9/15.
//  Copyright © 2015 Jason Larsen. All rights reserved.
//

import UIKit

class StartGameViewController : UIViewController {
    
    @IBAction func didPressStart() {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        
        presentViewController(vc, animated: false, completion: nil)
    }
}