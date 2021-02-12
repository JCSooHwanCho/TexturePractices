//
//  ViewController.swift
//  TexturePractice
//
//  Created by Joshua on 2021/02/12.
//

import UIKit
import AsyncDisplayKit

class ViewController: ASDKViewController<ASTableNode> {

    private var imageCategories: [String] = []
    private var tableNode: ASTableNode?

    override init() {
        super.init(node: ASTableNode())

        self.imageCategories = ["abstract", "animals", "business", "cats", "city", "food", "nightlife", "fashion", "people", "nature", "sports", "technics", "transport"]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK :- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Image Categories"

        self.node.delegate = self
        self.node.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = self.node.indexPathForSelectedRow {
            self.node.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }

    deinit {
        self.node.delegate = nil
        self.node.dataSource = nil
    }
}

extension ViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.imageCategories.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let imageCategory = self.imageCategories[indexPath.row]
        return {
            let textCellNode = ASTextCellNode()
            textCellNode.text = imageCategory.capitalized
            return textCellNode
        }
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let imageCategory = self.imageCategories[indexPath.row]

        let detailRootNode = DetailRootNode(with: imageCategory)
        let detailViewController = DetailViewController(node: detailRootNode)
        detailViewController.title = imageCategory.capitalized
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
