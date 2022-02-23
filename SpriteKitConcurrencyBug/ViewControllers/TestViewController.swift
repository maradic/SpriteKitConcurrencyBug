//
//  TestViewController.swift
//  SpriteKitConcurrencyBug
//
//  Created by Marinko Radic on 23.02.2022..
//

import UIKit
import SpriteKit

class TestViewController: UIViewController {
    weak var sceneDeleagte: CustomSceneDelegate?
    
    private let sceneView = SKView()
    
    private var scene: CustomScene! {
        return sceneView.scene as? CustomScene
    }
    
    deinit {
        printDeinitMessage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupBackButton()
    }
    
    private func setupBackButton() {
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "back-button"), style: .done, target: self, action:  #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func setupScene() {
        sceneView.allowsTransparency = true
        view.addSubview(sceneView)
        sceneView.pinEdges(to: view)
        
        let scene = CustomScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .cyan
        
        sceneView.presentScene(scene)
        sceneDeleagte?.sceneDidAddToView()
    }
            
    @objc private func backButtonTapped() {
        sceneDeleagte?.backButtonTapped()
    }
    
    public func startIntro() async {
        await scene.startIntro()
    }
    
    // reproduces bug. TestViewController stays in memory because startIntro() is not completed
    public func clearAll() {
        scene.isPaused = true
        scene.removeAllActions()
        scene.removeAllChildren()
    }
    
    // First solution thanks to Jure Lajlar
    public func firstWorkAround() {
        scene.isPaused = false
        scene.children.filter { $0 is SKAudioNode }.forEach { $0.run(.stop()) }
        scene.run(.fadeOut(withDuration: 0.1))
        scene.speed = 10000
    }
    
    // Second solution thanks to Jure Lajlar
    public func secondWorkAround() {
        scene.children.forEach { node in
            if let baseNode = node as? BaseNode {
                baseNode.removeAllActions()
            }
        }
    }
}

public extension UIView {
    func pinEdges(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension UIViewController {
    func printDeinitMessage() {
        print("Deinit for class \(self.description)")
    }
}
