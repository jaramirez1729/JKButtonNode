//
//  GameScene.swift
//  JKButtonNode
//
//  Created by Jozemite Apps on 8/30/16.
//  Copyright (c) 2016 Jozemite Apps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Button declaration with just a background
    let playButton = JKButtonNode(backgroundNamed: "PlayButtonNormal")
    
    //Button that will be initialized later
    var continueButton: JKButtonNode!
    
    //Button that has a title 
    var textButton = JKButtonNode(title: "Press me!", state: .normal)
    
    //Music button that doesn't actually do anything, jsut for example
    var musicButton: JKButtonNode!
    var isMusicOn = true
    
    var newGameButton = JKButtonNode(title: "New Game", state: .normal)
    
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Called when the play button is pressed.
    func playButtonAction(_ button: JKButtonNode) {
        print("The play button has been pressed.")
    }
    
    //Called when the continue button is pressed.
    func continueButtonAction(_ button: JKButtonNode) {
        //Will not be called because the button is disabled.
        print("The continue button has been pressed.")
    }
    
    //Called when the text button is pressed.
    func textButtonAction(_ button: JKButtonNode) {
        var words = ["I'm a button.", "Press me!", "Press me again!", "Hello World!", "Enter text.", "Hi!"]
        words = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: words) as! [String]
        textButton.title.text = words[0]
    }
    
    //Called when the music button is pressed.
    func musicButtonAction(_ button: JKButtonNode) {
        isMusicOn = !isMusicOn
        isMusicOn ? (musicButton.texture = SKTexture(imageNamed: "MusicButtonOn")) : (musicButton.texture = SKTexture(imageNamed: "MusicButtonOff"))
    }
    
    
    override func didMove(to view: SKView) {
        let maxAspectRatio: CGFloat = deviceWidth / deviceHeight
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        playableArea = CGRect(x:0, y: playableMargin, width: size.width, height: playableHeight)
        backgroundColor = UIColor.black
        
        //The play button
        playButton.setBackgroundsForState(normal: "PlayButtonNormal", highlighted: "PlayButtonHighlighted", disabled: "")
        playButton.position = CGPoint(x: playableArea.midX - 200, y: playableArea.midY)
        playButton.action = playButtonAction
        playButton.normalSound = "NormalButtonSound"
        playButton.setSoundsFor(normalButton: "NormalButtonSound", andDisabledButton: "DisabledButtonSound")
        addChild(playButton)
        
        
        //The continue button initialized
        continueButton = JKButtonNode(backgroundNamed: "ContinueButtonDisabled", state: .disabled, action: continueButtonAction)
        continueButton.position = CGPoint(x: playableArea.midX + 200, y: playableArea.midY)
        continueButton.disabledSound = "DisabledButtonSound"
        addChild(continueButton)
        
        //The text button
        textButton.setBackgroundsForState(normal: "TextButtonNormal", highlighted: "TextButtonHighlighted", disabled: "")
        textButton.position = CGPoint(x: playableArea.midX, y: playableArea.midY - 240)
        textButton.title.text = "PUSH HERE" //Because the title is an SKLabelNode, you can access all the properties of an SKLabelNode.
        textButton.setSoundsFor(normalButton: "NormalButtonSound", andDisabledButton: "DisabledButtonSound")
        textButton.action = textButtonAction
        addChild(textButton)
        
        //The music button
        musicButton = JKButtonNode(backgroundNamed: "MusicButtonOn", action: musicButtonAction)
        musicButton.setProperties(enabled: true, canPlaySound: false, canChangeState: false, withSounds: (normal: "", disabled: ""))
        musicButton.position = CGPoint(x: playableArea.minX + (musicButton.size.width * 1.2), y: playableArea.maxY - (musicButton.size.height * 1.2))
        addChild(musicButton)
        
        //If you are going to have several buttons with the same properties but different titles, you can create an array
        //of the buttons and then call forEach on the array to assign similiar properties all at once.
    }
}
