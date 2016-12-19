//
//  WallGenerator.swift
//  Portal Run
//
//  Created by Steven Holman on 12/5/16.
//  Copyright © 2016 Portal Run Team. All rights reserved.
//

import Foundation
import SpriteKit

class WallGenerator: SKSpriteNode {
    var walls = [Wall]()
    var generatingWalls = false
    var movingWalls = false
    var frameCount = 0.0
    
    
    func generateWall() {
        let wall = Wall()
        wall.position.x = size.width 
        if Currently_At == 1 {
            wall.position.y =  TopHeight + wall.size.height/2 + 10
            
        }
        if Currently_At == 2 {
            wall.position.y =  CenterHeight + wall.size.height/2 + 10

            
        }
        if Currently_At == 3 {
            wall.position.y =  BottomHeight + wall.size.height/2 + 10

        }
        addChild(wall)
        walls.append(wall)
    }
    
    func startGeneratingWalls() {
        self.generatingWalls = true
        self.movingWalls = true
    }
    
    func stopGeneratingWalls() {
        self.generatingWalls = false
        self.movingWalls = false
        
        self.frameCount = 0.0
    }
    
    func update(delta: TimeInterval) {
        if self.generatingWalls {
            self.frameCount += delta
            
            if self.frameCount >= 3.0 {
                self.generateWall()
                
                self.frameCount = 0.0
            }
        }
        
        if self.movingWalls {
            for node in self.children {
                if let wall = node as? Wall {
                    wall.updateLocation(delta: delta)
                }
            }
        }
    }
    
 
}
