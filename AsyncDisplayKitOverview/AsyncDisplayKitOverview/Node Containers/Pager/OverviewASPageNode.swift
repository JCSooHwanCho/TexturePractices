//
//  OverviewASPageNode.swift
//  AsyncDisplayKitOverview
//
//  Created by Joshua on 2021/02/15.
//

import AsyncDisplayKit

final class OverviewASPageNode: ASCellNode {
    override func calculateLayoutThatFits(_ constrainedSize: ASSizeRange) -> ASLayout {
        return ASLayout(layoutElement: self, size: constrainedSize.max)
    }
}
