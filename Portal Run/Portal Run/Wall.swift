//
//  Wall.swift
//  Portal Run
//
//  Created by Steven Holman on 12/5/16.
//  Copyright © 2016 Portal Run Team. All rights reserved.
//

import Foundation
import SpriteKit

class Wall: SKSpriteNode {
    let Wall_WIDTH = 30.0
    let Wall_HEIGHT = 50.0
    let Wall_COLOR = UIColor.clear
    let obstacles = ["icon-images/bush.png", "icon-images/tree.png","icon-images/turret.png"]
    
    init() {
        let size = CGSize(width: Wall_WIDTH, height: Wall_HEIGHT)
        super.init(texture: nil, color: Wall_COLOR, size: size)
        loadPhysicsBody(size: size)
        let randomIndex = Int(arc4random_uniform(UInt32(obstacles.count)))
        let obstacle = obstacles[randomIndex]
        texture = SKTexture(imageNamed: obstacle)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLocation(delta: TimeInterval) {
        self.position.x = self.position.x - CGFloat(CGFloat(delta) * moveSpeed/2)
        
        if self.position.x < 0 {
            self.removeFromParent()
        }
    }
    
    func loadPhysicsBody(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = wallCatergory
        physicsBody?.affectedByGravity = false
        
    }
    
    func stop(){
        removeAllActions()
    }
    
}

