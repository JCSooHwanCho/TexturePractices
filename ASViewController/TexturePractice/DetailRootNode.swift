//
//  DetailRootNode.swift
//  TexturePractice
//
//  Created by Joshua on 2021/02/12.
//

import UIKit
import AsyncDisplayKit

fileprivate let kImageSize = CGFloat(200.0)

final class DetailRootNode: ASDisplayNode {
    var collectionNode: ASCollectionNode

    private var imageCategory: String

    init(with imageCategory: String) {
        let layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.imageCategory = imageCategory

        super.init()

        self.automaticallyManagesSubnodes = true

        self.collectionNode.backgroundColor = .white
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
    }

    deinit {
        collectionNode.delegate = nil
        collectionNode.dataSource = nil
    }

    // MARK :- ASDisplayNode
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: self.collectionNode)
    }
}

extension DetailRootNode: ASCollectionDataSource, ASCollectionDelegate {
    // MARK :- ASCollectionDataSource
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let imageCategory = self.imageCategory
        return {
            let node = DetailCellNode()
            node.row = indexPath.row
            node.imageCategory = imageCategory
            return node
        }
    }

    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let imageSize = CGSize(width: collectionNode.view.frame.width, height: kImageSize)

        return ASSizeRange(min: imageSize, max: imageSize)
    }
}
