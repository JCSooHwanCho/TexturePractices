//
//  OverviewASTableNode.swift
//  AsyncDisplayKitOverview
//
//  Created by Joshua on 2021/02/15.
//

import AsyncDisplayKit

final class OverviewASTableNode: ASDisplayNode {
    let node: ASTableNode

    override init() {
        self.node = ASTableNode()
        super.init()

        self.node.dataSource = self
        self.addSubnode(self.node)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.node.style.width = ASDimension(unit: .fraction, value: 1.0)
        self.node.style.height = ASDimension(unit: .fraction, value: 1.0)
        return ASWrapperLayoutSpec(layoutElement: self.node)
    }
}

extension OverviewASTableNode: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {

        return {
            let cellNode = ASTextCellNode()
            cellNode.text = String(format: "Row: %ld", indexPath.row)
            return cellNode
        }
    }
}
