//
//  OverviewDetailViewController.swift
//  AsyncDisplayKitOverview
//
//  Created by Joshua on 2021/02/15.
//

import AsyncDisplayKit

class OverviewDetailViewController: UIViewController {

    private let node: ASDisplayNode

    init(with node: ASDisplayNode) {
        self.node = node
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.view.addSubnode(self.node)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let bounds = self.view.bounds
        let nodeSize = self.node.layoutThatFits(ASSizeRange(min: .zero, max: bounds.size)).size
        self.node.frame = CGRect(x: bounds.midX - nodeSize.width / 2,
                                 y: bounds.midY - nodeSize.height / 2,
                                 width: nodeSize.width,
                                 height: nodeSize.height)
    }
}
