//
//  CloudGenerator.swift
//  Portal Run
//
//  Created by Phat Pham on 12/7/16.
//  Copyright © 2016 Portal Run Team. All rights reserved.
//

import UIKit
import SpriteKit

class CloudGenerator: SKSpriteNode {
    
    var clouds = [Cloud]()
    
    private var generatingClouds = false
    private var movingClouds = false
    private var frameCount = 0.0
    
    func generateCloud() {
        let cloud = Cloud()
        cloud.position.x = size.width
        if Currently_At == 1 {
            cloud.position.y =  TopHeight + cloud.size.height/2 + 60
            
        }
        if Currently_At == 2 {
            cloud.position.y =  CenterHeight + cloud.size.height/2 + 60
            
            
        }
        if Currently_At == 3 {
            cloud.position.y =  BottomHeight + cloud.size.height/2 + 60
            
        }
        addChild(cloud)
        clouds.append(cloud)
    }
    
    func startGeneratingClouds() {
        self.generatingClouds = true
        self.movingClouds = true
    }
    
    func stopGeneratingClouds() {
        self.generatingClouds = false
        self.movingClouds = false
        
        self.frameCount = 0.0
    }
    
    func update(delta: TimeInterval) {
        if self.generatingClouds {
            self.frameCount += delta
            
            if self.frameCount >= 3.0 {
                self.generateCloud()
                
                self.frameCount = 0.0
            }
        }
        
        if self.movingClouds {
            for node in self.children {
                if let cloud = node as? Cloud {
                    cloud.updateLocation(delta: delta)
                }
            }
        }
    }

}
