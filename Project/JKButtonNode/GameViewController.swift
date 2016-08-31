//
//  GameViewController.swift
//  JKButtonNode
//
//  Created by Jozemite Apps on 8/30/16.
//  Copyright (c) 2016 Jozemite Apps. All rights reserved.
//

import UIKit
import SpriteKit

var deviceWidth = UIScreen.mainScreen().bounds.width
var deviceHeight = UIScreen.mainScreen().bounds.height
var playableArea: CGRect!

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: CGSize(width: 1334, height: 750))
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }
}
