//
//  GameScene.swift
//  Eyeliner
//
//  Created by Kevin Bi on 6/29/17.
//  Copyright © 2017 Kevelopment. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var rightLine : SKShapeNode?;
    private var leftLine : SKShapeNode?;
    private var lblInstructions : SKLabelNode?;
    private var lblTapInstruct : SKLabelNode?;
    private var redTouched : Bool = false;
    private var greenTouched : Bool = false;
    private var screenHeight : CGFloat = 0;
    private var screenWidth : CGFloat = 0;
    private var btnFinished : SKShapeNode?;
    private var viewController : GameViewController?;
    
    private var rightValues : Array<CGFloat> = [255.0, 0, 0];
    private var leftValues : Array<CGFloat> = [0, 255.0, 0];
    
    private let X_SCALE = CGFloat(5.5);
    private let Y_SCALE = CGFloat(0.6);


    //Initialization function
    override func didMove(to view: SKView) {
        //Gets the screen height and width
        screenHeight = self.size.height;
        screenWidth = self.size.width;
        
        //Establishes node references
        
        let linePath = CGPath(roundedRect: CGRect(x: 0, y: 0, width: screenWidth * 0.8, height: screenHeight * 0.075), cornerWidth: 50, cornerHeight: 50, transform: nil);
        
        rightLine = SKShapeNode(path: linePath, centered: true);
        leftLine = SKShapeNode(path: linePath, centered: true);
        
        rightLine!.isAntialiased = false;
        leftLine!.isAntialiased = false;
        
        rightLine!.name = "rightLine";
        leftLine!.name = "leftLine";
        
        self.addChild(rightLine!);
        self.addChild(leftLine!);
        
        lblInstructions = self.childNode(withName: "lblInstructions") as? SKLabelNode;
        lblTapInstruct = self.childNode(withName: "lblTapInstruct") as? SKLabelNode;
        btnFinished = self.childNode(withName: "btnFinished") as? SKShapeNode;
        
        
        loadData();
        
        rightLine!.strokeColor = rightLine!.fillColor;
        leftLine!.strokeColor = leftLine!.fillColor;
        
        //Programmatic positioning code
        lblInstructions!.position.y = screenHeight * 0.35
        lblInstructions!.position.x = 0;
        lblTapInstruct!.position.y = lblInstructions!.position.y - (screenHeight * 0.05);
        lblTapInstruct!.position.x = 0;
        rightLine!.position.y = (screenHeight * 0.12);
        leftLine!.position.y = -(screenHeight * 0.12);
        
        btnFinished!.position.y = -(screenHeight * 0.3);
        rightLine!.run(SKAction.rotate(byAngle: degToRad(CGFloat(arc4random_uniform(40))), duration: 0));
        leftLine!.run(SKAction.rotate(byAngle: degToRad(CGFloat(arc4random_uniform(40))), duration: 0));
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Gets touch position and the touched node
        let touch = touches.first;
        let touchPos = touch?.location(in: self);
        let touchedNode = self.nodes(at: touchPos!).first;
        
        //Sets up flag for which node is touched
        if(touchedNode?.name == rightLine?.name){
            redTouched = true;
        }
        else if(touchedNode?.name == leftLine?.name){
            greenTouched = true;
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Gets touch info
        let touch = touches.first!;
        let touchPos = touch.location(in:self);
        
        //Takes actions depending on touched node
        if(redTouched){
            touchAngle(rightLine, touchPos);
        }
        else if(greenTouched){
            touchAngle(leftLine, touchPos);
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Gets touch data
        let touch = touches.first!;
        let touchPos = touch.location(in: self);
        let touchedNode = self.nodes(at: touchPos).first;
        
        //Checks for touch on btnFinished or the embedded label node.
        if (touchedNode != nil && (touchedNode!.name == btnFinished!.name || touchedNode!.name == "lblFinished")){
            //Goes to ResultViewController and passes information
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let controller = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController;
            controller.setAngles(top: rightLine!.zRotation, bottom: leftLine!.zRotation);
            self.viewController?.present(controller, animated: true, completion: nil);
        }
        else if(!redTouched && !greenTouched){
            //Runs increment code depending on location.
            if(touchPos.y > 0){
                tapIncrement(rightLine, touchPos);
            }
            else if(touchPos.y < 0){
                tapIncrement(leftLine, touchPos);
            }
        }
        redTouched = false;
        greenTouched = false;
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //Converts degrees to radians
    func degToRad(_ deg: CGFloat) -> CGFloat{
        return deg * CGFloat.pi / 180;
    }
    
    //Sets the angle depending on touch location
    func touchAngle(_ line: SKShapeNode?, _ touchPos: CGPoint){
        let tan = (touchPos.y - line!.position.y) / (touchPos.x - line!.position.x);
        line!.run(SKAction.rotate(toAngle: atan(tan), duration: 0));
    }
    
    
    //Increments by one degree when tapped
    func tapIncrement(_ line: SKShapeNode?, _ touchPos: CGPoint){
        let yScale = touchPos.y > line!.position.y ? 1 : -1;
        let xScale = touchPos.x > line!.position.x ? 1 : -1;
        
        line!.run(SKAction.rotate(byAngle: degToRad(CGFloat(yScale * xScale)), duration: 0));
        
    }
    
    //Loads all settings data
    func loadData(){
        let defaults = UserDefaults.standard;
        
        //Gets the RGB values for each
        for i in 0 ..< rightValues.count{
            rightValues[i] = CGFloat(defaults.float(forKey: "RIGHT" + String(describing: i)));
            leftValues[i] = CGFloat(defaults.float(forKey: "LEFT" + String(describing: i)));
        }
        
        //Set colors for lines
        rightLine!.fillColor = UIColor(red: rightValues[0] / 255, green: rightValues[1] / 255, blue: rightValues[2] / 255, alpha: 1);
        leftLine!.fillColor = UIColor(red: leftValues[0] / 255, green: leftValues[1] / 255, blue: leftValues[2] / 255, alpha: 1);
        
        //Set colors for background
        let bgValue = CGFloat(defaults.float(forKey: AppDelegate.KEY_BG));
        self.backgroundColor = UIColor(red: bgValue / 255, green: bgValue / 255, blue: bgValue / 255, alpha: bgValue);
    }
    
    func setViewController(controller : GameViewController?){
        self.viewController = controller;
    }

}
