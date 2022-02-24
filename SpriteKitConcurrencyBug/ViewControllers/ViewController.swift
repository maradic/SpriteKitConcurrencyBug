//
//  ViewController.swift
//  SpriteKitConcurrencyBug
//
//  Created by Marinko Radic on 23.02.2022..
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var bugButton: UIButton!
    
    var testController: TestViewController? {
        return navigationController?.viewControllers.last as? TestViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func bugButtonTapped(_ sender: Any) {
        let nextController = TestViewController()
        nextController.sceneDeleagte = self
        navigationController?.pushViewController(nextController, animated: true)
    }
    
}

extension ViewController: CustomSceneDelegate {
    func sceneDidAddToView() {
        guard let controller = testController else { return }      
        Task {
            try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
            await controller.startIntro()
            print("intro done")
        }
    }
    
    func backButtonTapped() {
        // reproduces bug. TestViewController stays in memory because startIntro() is not completed
        testController?.clearAll()
        
        // first workaround
//        testController?.firstWorkAround()
        
        // second workaround
//        testController?.secondWorkAround()
        navigationController?.popViewController(animated: false)
    }
}
