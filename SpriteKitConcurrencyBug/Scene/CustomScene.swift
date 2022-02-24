//
//  CustomScene.swift
//  SpriteKitConcurrencyBug
//
//  Created by Marinko Radic on 23.02.2022..
//

import Foundation
import SpriteKit

class CustomScene: SKScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = .orange
    }
    
    @MainActor
    func startIntro() async {
        let raisingApple = BaseNode(texture: SKTexture(imageNamed: "balloon-red"), color: .clear, size: .init(width: 50, height: 50))
        raisingApple.size = CGSize(width: 57, height: 90)
        raisingApple.anchorPoint = CGPoint(x: 0.5, y: 1)
        raisingApple.position = CGPoint(x: frame.midX, y: 0)
        let pointOutOfTheScreen = CGPoint(x: frame.midX, y: frame.height + raisingApple.size.height)
        let moveAction = SKAction.move(to: pointOutOfTheScreen, duration: 15)
        
        addChild(raisingApple)
        
        await raisingApple.runAction(moveAction)
    }
}
