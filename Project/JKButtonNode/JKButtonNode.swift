/*
 * Copyright (c) 2016 Jozemite Apps May 26, 2016
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/*  The JKButtonNode class is a very easy class used to display buttons in a SpriteKit game.
 *  The class uses an SKLabelNode on top of an SKTexture, which makes it easier for users to
 *  manipulate the buttons since they utilize all of the SKLabelNode and SKTexture properties.
 */

import SpriteKit

/**The various states a JKButtonNode object can be.*/
public enum JKButtonState {
    
    /**The normal, or default state of a button—that is, enabled but not highlighted.*/
    case normal
    
    /**Highlighted state of a button. A button becomes highlighted when a touch event 
     enters the button's bounds, and it loses that highlight when there is a touch-up 
     event or when the touch event exits the button's bounds.*/
    case highlighted
    
    /**Disabled state of a button. User interactions with disabled button have no effect 
     and the control draws itself with a specific background noting it's disabled.*/
    case disabled
}

/**A JKButtonNode is used to display a button in SpriteKit that is composed of an SKSpriteNode and an SKLabelNode.*/
class JKButtonNode: SKSpriteNode {

    //--------------------
    //-----Properties-----
    //--------------------
    /**Whether to allow the button to be pressed. Setting it to false will also assign the correct background image
       and the button's state to disabled.*/
    var enabled = true {
        didSet {
            enabled ? setState(.normal) : (canChangeState ? setState(.disabled): setState(.normal))
        }
    }
    
    /**Prevents the button from calling its action property when pressed. A custom action can be done
     by calling containsPoint on the button itself inside the touch functions and passing the user's touch.
     This type of custom action will activate as soon as the user touches the button.*/
    var useCustomAction = false {
        didSet {
            useCustomAction ? (userInteractionEnabled = false) : (userInteractionEnabled = true)
        }
    }
    
    //Whether the button can make sounds.
    var canPlaySounds = true
    
    /**Whether the button can change states when pressed or disabled.
       This will not change the current background of the button.*/
    var canChangeState = true
    
    //BUG: Having empty strings will play any random sound file even when checking
    //if the strings are empty.
    /**The sound that is played when the user releases the button.*/
    var normalSound = ""
    
    /**The sound that is played when the user attempts to touch a disabled button.*/
    var disabledSound = ""

    /**The function to call after the button has been pressed successfully.*/
    var action:((button: JKButtonNode) -> Void)?
    
    //The state of the button only accessed by the class.
    private var state: JKButtonState = .normal
    
    /**The string that the button displays.*/
    var title: SKLabelNode!
    
    /**The default background of the button when there is no interaction. 
       All other button states will be assigned this image unless otherwise specified.*/
    var normalBG = SKTexture(imageNamed: "")
    
    /**The background of the button when it has been pressed.*/
    var highlightedBG = SKTexture(imageNamed: "")
    
    /**The background of the button when the button is not allowed to be pressed.*/
    var disabledBG = SKTexture(imageNamed: "")
    
    
    //----------------------
    //-----Initializers-----
    //----------------------
    /**Initializes a new button with just a background and no title.
       You can declare the button's action later if you choose not to at initialization.*/
    init(background: SKTexture, action: ((button: JKButtonNode) -> Void)? = nil) {
        self.title = SKLabelNode(text: "")
        self.action = action
        super.init(texture: background, color: UIColor.clearColor(), size: background.size())
        finalizeInit(state: .normal, background: background)
    }
    
    /**Initializes a new button with a specific background for the specified state.
       You can declare the button's action later if you choose not to at initialization.*/
    init(background: SKTexture, state: JKButtonState, action: ((button: JKButtonNode) -> Void)? = nil) {
        self.title = SKLabelNode(text: "")
        self.action = action
        self.state = state
        super.init(texture: background, color: UIColor.clearColor(), size: background.size())
        finalizeInit(state: state, background: background)
    }
    
    /**Initializes a new button with a title and specified state.
       You can set the state backgrounds by calling setStateBackgrounds on the button.*/
    init(title: String, state: JKButtonState, action: ((button: JKButtonNode) -> Void)? = nil) {
        self.title = SKLabelNode(text: title)
        self.action = action
        self.state = state
        super.init(texture: normalBG, color: UIColor.clearColor(), size: normalBG.size())
        finalizeInit(state: state, background: nil)
    }
    
    /**Initializes a new button with a title and background.*/
    init(title: String, background: SKTexture, action: ((button: JKButtonNode) -> Void)? = nil) {
        self.title = SKLabelNode(text: title)
        self.action = action
        super.init(texture: background, color: UIColor.clearColor(), size: background.size())
        finalizeInit(state: .normal, background: background)
    }
    
    /** Initializes a new button with specific properties.*/
    init(title: String, background: SKTexture, state: JKButtonState, action: ((button: JKButtonNode) -> Void)? = nil) {
        self.title = SKLabelNode(text: title)
        self.action = action
        self.state = state
        super.init(texture: background, color: UIColor.clearColor(), size: background.size())
        finalizeInit(state: state, background: background)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //-------------------------
    //-----Private Methods-----
    //-------------------------
    //Shared function to be used by initializers only
    private func finalizeInit(state state: JKButtonState, background: SKTexture?) {
        if let bg = background {
            setState(state, andBackground: bg)
        } else {
            setState(state)
        }
        if let title = self.title {
            assignTitleProperties()
            title.zPosition = 10
            addChild(title)
        }
        userInteractionEnabled = true
    }
    
    //Assigns default values for the title.
    private func assignTitleProperties(fontName name: String? = "Chalkduster", size: CGFloat = 50, color: UIColor = UIColor.blackColor()) {
        title.fontName = name
        title.fontColor = color
        title.fontSize = size

        //This equation is used to center the label vertically when the font size is changed
        title.position = CGPoint(x: 0, y: 0 - (self.title.fontSize * 0.4))
    }
    
    //Set the current state of the button with the specified background.
    private func setState(state: JKButtonState, andBackground background: SKTexture) {
        self.state = state
        switch state {
        case .normal:
            normalBG = background
            self.texture = normalBG
        case .highlighted:
            highlightedBG = background
            self.texture = highlightedBG
        case .disabled:
            disabledBG = background
            self.texture = disabledBG
            enabled = false
        }
    }
    
    //Check to make sure that the sounds have been set before trying to play any.
    private func play(sound: String) {
        if sound.isEmpty {
            print("Failed to play button sound because it has not been set.")
        } else {
            runAction(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
        }
    }
    
    
    //------------------------
    //-----Public Methods-----
    //------------------------
    /**A convenient way to set several values at once.*/
    func setProperties(enabled enabled: Bool, canPlaySound canPlay: Bool, canChangeState canChange: Bool, withSounds sounds: (normal: String, disabled: String)) {
        self.enabled = enabled
        self.canPlaySounds = canPlay
        self.canChangeState = canChange
        self.normalSound = sounds.normal
        self.disabledSound = sounds.disabled
    }
    
    /**Set specific backgrounds for each of the button states.*/
    func setBackgroundsForState(normal normal: String, highlighted: String, disabled: String) {
        self.normalBG = SKTexture(imageNamed: normal)
        self.size = SKTexture(imageNamed: normal).size()
        self.highlightedBG = SKTexture(imageNamed: highlighted)
        self.disabledBG = SKTexture(imageNamed: disabled)
        setState(self.state)
    }
    
    /**Set the sounds to play when button has been pressed or when it can't be pressed.*/
    func setSoundsFor(normalButton normalButton: String, andDisabledButton disabledButton: String) {
        self.normalSound = normalButton
        self.disabledSound = disabledButton
    }
    
    /**Assign custom properties for the title.*/
    func setPropertiesForTitle(fontName font: String?, size: CGFloat, color: UIColor) {
        title.fontName = font
        title.fontColor = color
        title.fontSize = size
        
        //This equation is used to center the label vertically into the background when the font size is changed
        title.position = CGPoint(x: 0, y: 0 - (self.title.fontSize * 0.4))
    }
    
    /**Set the current state of the button. This will also apply the appropriate background.*/
    func setState(state: JKButtonState) {
        switch state {
        case .normal: self.texture = normalBG
        case .highlighted: self.texture = highlightedBG
        case .disabled: self.texture = disabledBG
        }
    }
    
    
    //-------------------------
    //-----Touch Functions-----
    //-------------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if enabled {
            if canChangeState {
                setState(.highlighted)
            }
        } else if canPlaySounds {
            play(disabledSound)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if enabled {
            if canChangeState {
                setState(.highlighted)
            }
            
            //Cancels the touch if the user moved their finger out of the button's frame
            if let touch = touches.first {
                let location = touch.locationInNode(parent!)
                if !self.containsPoint(location) {
                    setState(.normal)
                    userInteractionEnabled = false
                    userInteractionEnabled = true
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if enabled {
            setState(.normal)
            
            //Allows the action to be complete only if they let go of the button
            if userInteractionEnabled {
                if let buttonAction = action {
                    if let touch = touches.first {
                        let location = touch.locationInNode(parent!)
                        if self.containsPoint(location) {
                            if canPlaySounds {
                                play(normalSound)
                            }
                            buttonAction(button: self)
                        }
                    }
                }
            }
        }
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if enabled {
            setState(.normal)
        }
    }
}