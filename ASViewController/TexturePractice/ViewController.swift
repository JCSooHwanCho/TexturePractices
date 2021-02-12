//
//  ViewController.swift
//  TexturePractice
//
//  Created by Joshua on 2021/02/12.
//

import UIKit
import AsyncDisplayKit

// 전체적인 사용방법은 뷰컨트롤러와 크게 다르지 않다.
class ViewController: ASDKViewController<ASTableNode> {

    private var imageCategories: [String] = []
    private var tableNode: ASTableNode?

    override init() {
        super.init(node: ASTableNode()) // 특정 노드를 넣어서 초기화

        self.imageCategories = ["abstract", "animals", "business", "cats", "city", "food", "nightlife", "fashion", "people", "nature", "sports", "technics", "transport"]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK :- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
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

// TableView, CollectionView 의 delegate는 View가 Node로 바뀐 정도다.
extension ViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.imageCategories.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let imageCategory = self.imageCategories[indexPath.row]
        return {
            // TextCellNode: 라벨 하나를 제공하는 노드
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
