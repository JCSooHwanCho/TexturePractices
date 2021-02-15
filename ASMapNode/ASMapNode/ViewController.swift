//
//  ViewController.swift
//  ASMapNode
//
//  Created by Joshua on 2021/02/14.
//

import AsyncDisplayKit

class ViewController: ASDKViewController<MapHandlerNode> {

    override init() {
        super.init(node: MapHandlerNode())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = true
    }
}

