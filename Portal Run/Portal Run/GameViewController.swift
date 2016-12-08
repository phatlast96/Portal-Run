//
//  GameViewController.swift
//  Portal Run
//
//  Created by Phat Pham on 11/11/16.
//  Copyright © 2016 Portal Run Team. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var scene: GameScene!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let scene = GameScene(size: view.bounds.size)
        scene.viewController = self
        self.view = SKView(frame: self.view.frame)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func createButton() {
        let backButton = UIButton(frame: CGRect(x: self.view.bounds.size.width * 1/2, y: 300, width: 30, height: 40))
        backButton.backgroundColor = UIColor.gray
        backButton.setTitle("Demo", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Menlo-Regular", size: (backButton.titleLabel?.font.pointSize)!)
        backButton.addTarget(self, action: #selector(quit), for: .touchUpInside)
        backButton.sizeToFit()
        backButton.layer.cornerRadius = 1
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
    }
    func quit() {
        let startVC = StartScreenViewController()
        self.navigationController?.pushViewController(startVC, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
