//
//  SupplementaryNode.swift
//  ASCollectionView
//
//  Created by Joshua on 2021/02/13.
//

import AsyncDisplayKit

fileprivate let kInsets = CGFloat(15)

final class SupplementaryNode: ASCellNode {
    let textNode = ASTextNode()

    private var textAttributes: [NSAttributedString.Key: Any] {
        return [.font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.white]
    }

    init(with string: String) {
        super.init()

        self.textNode.attributedText = NSAttributedString(string: string, attributes: self.textAttributes)
        self.addSubnode(self.textNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let centerSpec = ASCenterLayoutSpec()
        centerSpec.centeringOptions = .XY
        centerSpec.child = self.textNode
        let insets = UIEdgeInsets(top: kInsets, left: kInsets, bottom: kInsets, right: kInsets)

        return ASInsetLayoutSpec(insets: insets, child: centerSpec)
    }
}

