//
//  OverviewASCollectionNode.swift
//  AsyncDisplayKitOverview
//
//  Created by Joshua on 2021/02/15.
//

import AsyncDisplayKit

final class OverviewASCollectionNode: ASDisplayNode {

    private var node: ASCollectionNode

     override init() {
        let flowLayout = UICollectionViewFlowLayout()

        self.node = ASCollectionNode(collectionViewLayout: flowLayout)

        super.init()

        self.node.dataSource = self
        self.node.delegate = self

        self.addSubnode(self.node)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.node.style.width = ASDimension(unit: .fraction, value: 1.0)
        self.node.style.height = ASDimension(unit: .fraction, value: 1.0)

        return ASWrapperLayoutSpec(layoutElement: self.node)
    }
}

extension OverviewASCollectionNode: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let cellNode = ASTextCellNode()
            cellNode.backgroundColor = .lightGray
            cellNode.text = String(format: "Row: %ld", indexPath.row)

            return cellNode
        }
    }
}

extension OverviewASCollectionNode: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRangeMake(CGSize(width: 100, height: 100))
    }
}
