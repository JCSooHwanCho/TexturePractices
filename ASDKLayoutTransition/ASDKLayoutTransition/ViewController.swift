//
//  ViewController.swift
//  ASDKLayoutTransition
//
//  Created by Joshua on 2021/02/14.
//

import AsyncDisplayKit

class ViewController: UIViewController {

    let transitionNode = TransitionNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.transitionNode.backgroundColor = .gray
        self.view.addSubnode(self.transitionNode)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let size = self.transitionNode.layoutThatFits(ASSizeRange(min: .zero, max: self.view.frame.size)).size

        self.transitionNode.frame = CGRect(x: 0, y: 20, width: size.width, height: size.height)
    }
}

