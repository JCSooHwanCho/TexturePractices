//
//  OverviewTitleDescriptionCellNode.swift
//  AsyncDisplayKitOverview
//
//  Created by Joshua on 2021/02/15.
//

import AsyncDisplayKit

final class OverviewTitleDescriptionCellNode: ASCellNode {
    let titleNode: ASTextNode
    let descriptionNode: ASTextNode

    override init() {
        self.titleNode = ASTextNode()
        self.descriptionNode = ASTextNode()

        super.init()

        self.automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let hasDescription = (self.descriptionNode.attributedText?.length ?? 0) > 0

        let verticalStackLayoutSpec = ASStackLayoutSpec.vertical()
        verticalStackLayoutSpec.alignItems = .start
        verticalStackLayoutSpec.spacing = 5.0
        verticalStackLayoutSpec.children = hasDescription ? [self.titleNode, self.descriptionNode]: [self.titleNode]

        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 10), child: verticalStackLayoutSpec)
    }
}
