//
//  GameScene.swift
//  Portal Run
//
//  Created by Phat Pham on 12/1/16.
//  Copyright © 2016 Portal Run Team. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewController: UIViewController!
    var button: SKNode! = nil
    var movingGround: MovingGround!
    var movingGroundTop: MovingGround!
    var movingGroundBottom: MovingGround!
    var hero: Hero!
    var isStarted = false
    var wallGenerator: WallGenerator!
    var isGameOver = false
    var portalGenerator: PortalGenerator!
    var cloudGenerator: CloudGenerator!
    var scoreboardData: ScoreboardData!
    var scoreboard: Scoreboard!
    var timer: Timer!
    var defaultMoveSpeed: CGFloat!
    var touchToStartlabel: SKLabelNode!
    
    override func didMove(to view: SKView) {

        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        movingGround = MovingGround(size: CGSize(width: view.frame.size.width * 2, height: 20))
        movingGround.position = CGPoint(x: 0, y: view.frame.size.height/2 - 40)
        addChild(movingGround)
        CenterHeight = view.frame.size.height/2 - 40
        movingGroundTop = MovingGround(size: CGSize(width: view.frame.size.width * 2, height: 20))
        movingGroundTop.position = CGPoint(x: 0, y: movingGround.position.y + 120 )
        addChild(movingGroundTop)
        TopHeight = movingGround.position.y + 120
        movingGroundBottom = MovingGround(size: CGSize(width: view.frame.size.width * 2, height: 20))
        movingGroundBottom.position = CGPoint(x: 0, y: movingGround.position.y - 120)
        addChild(movingGroundBottom)
        BottomHeight = movingGround.position.y - 120

        hero = Hero()
        hero.position = CGPoint(x: 70, y: movingGround.position.y + movingGround.frame.size.height/2 + hero.frame.size.height/2)
        addChild(hero)
        hero.breathe()
        Currently_At = 2
        
        wallGenerator = WallGenerator(color: UIColor.clear, size: view.frame.size)
        addChild(wallGenerator)
        physicsWorld.contactDelegate = self
        
        cloudGenerator = CloudGenerator(color: UIColor.clear, size: view.frame.size)
        addChild(cloudGenerator) // Needs fixing
        
        portalGenerator = PortalGenerator(color: UIColor.clear, size: view.frame.size)
        addChild(portalGenerator)
        
        // Adding the scoreboard
        scoreboard = Scoreboard(positionAt: CGPoint(x: view.center.x, y: view.center.y))
        addChild(scoreboard)
        
        touchToStartlabel = SKLabelNode(text: "Touch to Start!")
        touchToStartlabel.fontColor = UIColor.black
        touchToStartlabel.position.x = view.center.x
        touchToStartlabel.position.y = view.center.y + 40
        touchToStartlabel.fontName = "Helvetica"
        touchToStartlabel.fontSize = 22.0
        addChild(touchToStartlabel)

        // Necessary item needed to increase the difficulty of the game by speeding it up
        self.defaultMoveSpeed = moveSpeed
    }
    
    func placeTele(x: CGFloat, y: CGFloat){
        let diffs = [abs(Float(TopHeight - y)), abs(Float(CenterHeight - y)), abs(Float(BottomHeight - y))]
        let minimum = diffs.min()

        let position = diffs.index(of: minimum!) //Now if 0, goes to top, 1 goes to center, 2 goes to bot.
        portalGenerator.generatePortal(index: position!, x: x)
    }
    
    /** Indicates what happens when the user touches the screen when the GameScene is active. */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver{
            if let touch = touches.first {
                let position = touch.location(in: self)
                print(position.x, position.y)
                if button.contains(position) {
                    _ = self.viewController.navigationController?.popViewController(animated: true)
                }
            }
            self.removeChildren(in: [button])
            restart()
        }
        
        
        if !isStarted {
            touchToStartlabel.removeFromParent()
            movingGround.start()
            movingGroundTop.start()
            movingGroundBottom.start()
            hero.stop()
            hero.startRunning()
            wallGenerator.startGeneratingWallsEvery(seconds: 2.5)
            cloudGenerator.startGeneratingcloudsEvery(seconds: 7)
            // Adding the scoreboard data.
            
            scoreboardData = ScoreboardData()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: self.increaseDifficulty(timer:))
            isStarted = true
        } else {
            if let touch = touches.first {
                let position = touch.location(in: self)
                print(position.x, position.y)
                placeTele(x: position.x, y: position.y)

            }
        }

    }
    
    /** The display layout of the GameScene and actions to take when the game is over. */
    func gameOver(){
        isGameOver = true
        scoreboardData.stopTimer()
        moveSpeed = self.defaultMoveSpeed
        
        hero.physicsBody = nil
        wallGenerator.stopWalls()
        cloudGenerator.stopClouds()
        movingGround.stop()
        hero.stop()
        for portal in portals {
            portal.stop()
        }
        movingGroundTop.stop()
        movingGroundBottom.stop()
        
        let gameoverlabel = SKLabelNode(text: "Game Over!")
        gameoverlabel.fontColor = UIColor.red
        gameoverlabel.position.x = view!.center.x
        gameoverlabel.position.y = view!.center.y + 40
        gameoverlabel.fontName = "Helvetica"
        gameoverlabel.fontSize = 22.0
        addChild(gameoverlabel)
        
        if ScoreboardData.updateTopScore(score: self.scoreboardData.currentScore) {
            //TODO: Shows a medal if the score makes it to the top ten scores
        }
        button = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))
        button.position.x = view!.center.x
        button.position.y = view!.center.y - 40
        let text = SKLabelNode(text: "Quit")
        button.addChild(text)
        self.addChild(button)
    }
    
    func restart() {
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .aspectFill
        view!.presentScene(newScene)
    }
    
    func teleport() {
        var distances = [Float]()
        for i in portals {
            distances.append(abs(Float(hero.position.y - i.position.y)))
            
        }
        let closes = distances.min()
        let pos = distances.index(of: closes!)
        var new_loc:CGFloat = 0
        if pos == 1 {
            let move = SKAction.moveTo(y: portals[0].position.y, duration: 0.01)
            for i in portals {
                i.removeFromParent()
            }
            new_loc = portals[0].position.y
            portals.removeAll()
            hero.run(move)
            
        }
        
        if pos == 0 {
            if portals.count == 1 {
                portals[0].removeFromParent()
                portals.removeAll()
                return
            }
            let move = SKAction.moveTo(y: portals[1].position.y, duration: 0.01)
            for i in portals {
                i.removeFromParent()
            }
            new_loc = portals[1].position.y
            portals.removeAll()
            hero.run(move)

            
        }
        
        let diff = [abs(Float(TopHeight - new_loc)), abs(Float(CenterHeight - new_loc)), abs(Float(BottomHeight - new_loc))]
        let small = diff.min()
        print(diff)
        let position_small = diff.index(of: small!)
        Currently_At = position_small! + 1
        print(Currently_At)
        
        
        
        return
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        if (contact.bodyA.node as? Portal) != nil{
            teleport() //fill this in
        }
        else if (contact.bodyB.node as? Portal) != nil {
            teleport()
        }
        else {
            gameOver()
        }
        
    }
    
    /** Increases the difficulty of the game based how much time has elapsed during the session. */
    @objc func increaseDifficulty(timer: Timer) {
        if Int(scoreboardData.timeElapsed) % 5 == 0 {
            moveSpeed = CGFloat(moveSpeed) + CGFloat(10)
        }
        self.scoreboardData.updateScore(to: Int(scoreboardData.timeElapsed))
        self.scoreboard.updateScore(to: Int(scoreboardData.timeElapsed))
    }
    
    
    
}
