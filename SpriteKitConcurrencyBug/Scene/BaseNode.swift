//
//  JourneyBaseNode.swift
//
//
//  Created by Jure Lajlar on 14.12.2021..
//

import Foundation
import SpriteKit

class BaseNode: SKSpriteNode {
    
    var continuations: [String: CheckedContinuation<Void, Never>] = [:]
    
    override func removeAllActions() {
        children.forEach {
            $0.removeAllActions()
        }
        
        super.removeAllActions()
        
        for c in continuations {
            c.value.resume()
        }
        
        continuations.removeAll()
    }
    
    @available(*, deprecated, renamed: "runAction")
    override func run(_ action: SKAction) async {
        await super.run(action)
    }
    
    func runAction(_ action: SKAction) async {
        let key = UUID().uuidString
        await withCheckedContinuation { [weak self] (c: CheckedContinuation<Void, Never>) in
            self?.continuations[key] = c

            self?.run(action) { [weak self] in
                c.resume()
                self?.continuations[key] = nil
            }
        }
    }
}

extension SKAction {
    class func moveTo(y: CGFloat, duration: TimeInterval, timing: SKActionTimingMode) -> SKAction {
        let action = self.moveTo(y: y, duration: duration)
        action.timingMode = timing
        return action
    }
}
