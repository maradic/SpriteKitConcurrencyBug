//
//  CustomSceneDelegate.swift
//  SpriteKitConcurrencyBug
//
//  Created by Marinko Radic on 23.02.2022..
//

import Foundation

protocol CustomSceneDelegate: AnyObject {
    func sceneDidAddToView()
    func backButtonTapped()
}
