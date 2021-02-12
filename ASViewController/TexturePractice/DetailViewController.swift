//
//  DetailViewController.swift
//  TexturePractice
//
//  Created by Joshua on 2021/02/12.
//

import UIKit
import AsyncDisplayKit

final class DetailViewController: ASDKViewController<DetailRootNode> {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.node.collectionNode.view.collectionViewLayout.invalidateLayout()
    }
}
