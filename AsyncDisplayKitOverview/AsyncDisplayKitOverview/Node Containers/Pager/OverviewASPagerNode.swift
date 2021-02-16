//
//  OverviewASPagerNode.swift
//  AsyncDisplayKitOverview
//
//  Created by Joshua on 2021/02/15.
//

import AsyncDisplayKit

fileprivate func randomColor() -> UIColor {
    let hue = CGFloat.random(in: 0...1)
    let saturation = CGFloat.random(in: 0.5...1)
    let brightness = CGFloat.random(in: 0.5...1)

    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}

final class OverviewASPagerNode: ASDisplayNode {
    let node: ASPagerNode

    override init() {
        self.node = ASPagerNode()

        super.init()

        self.addSubnode(self.node)
        self.node.setDataSource(self)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.node.style.width = ASDimension(unit: .fraction, value: 1.0)
        self.node.style.height = ASDimension(unit: .fraction, value: 1.0)

        return ASWrapperLayoutSpec(layoutElement: self.node)
    }
}

extension OverviewASPagerNode: ASPagerDataSource {
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return 4
    }

    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        return {
            let cellNode = OverviewASPageNode()
            cellNode.backgroundColor = randomColor()
            return cellNode
        }
    }
}

