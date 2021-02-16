//
//  OverviewDisplayNodeWithSizeBlock.swift
//  AsyncDisplayKitOverview
//
//  Created by Joshua on 2021/02/15.
//

import AsyncDisplayKit

final class OverviewDisplayNodeWithSizeBlock: ASDisplayNode, ASLayoutSpecListEntry {
    typealias OverviewDisplayNodeSizeThatFitsBlock = (ASSizeRange) -> ASLayoutSpec

    var entryTitle: String?
    var entryDescription: String?
    var sizeThatFitsBlock: OverviewDisplayNodeSizeThatFitsBlock?

    init(entryTitle: String? = nil, entryDescription: String? = nil, sizeThatFitsBlock: OverviewDisplayNodeWithSizeBlock.OverviewDisplayNodeSizeThatFitsBlock? = nil) {
        self.entryTitle = entryTitle
        self.entryDescription = entryDescription
        self.sizeThatFitsBlock = sizeThatFitsBlock
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        guard let block = self.sizeThatFitsBlock else {
            return super.layoutSpecThatFits(constrainedSize)
        }

        return block(constrainedSize)
    }
}
