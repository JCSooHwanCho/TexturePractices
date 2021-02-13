//
//  ItemNode.swift
//  ASCollectionView
//
//  Created by Joshua on 2021/02/14.
//

import AsyncDisplayKit

final class ItemNode: ASTextCellNode {
    override var isSelected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    convenience init(with text: String) {
        self.init() // convenience init이기 때문에 designated Initializer 내부에서 호출하면 크래시
        // 관련 링크: https://github.com/facebookarchive/AsyncDisplayKit/issues/1333
        self.text = text

        self.updateBackgroundColor()
    }

    func updateBackgroundColor() {
        if self.isHighlighted {
            self.backgroundColor = .gray
        } else if self.isSelected {
            self.backgroundColor = .darkGray
        } else {
            self.backgroundColor = .lightGray
        }
    }
}
