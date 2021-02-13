//
//  PresentingViewController.swift
//  ASCollectionView
//
//  Created by Joshua on 2021/02/13.
//

import UIKit

final class PresentingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Push Details",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(pushNewViewController))
    }

    @objc func pushNewViewController() {
        let controller = ViewController()

        self.navigationController?.pushViewController(controller, animated: true)
    }
}
