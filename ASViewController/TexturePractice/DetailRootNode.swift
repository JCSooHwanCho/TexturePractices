//
//  DetailRootNode.swift
//  TexturePractice
//
//  Created by Joshua on 2021/02/12.
//

import UIKit
import AsyncDisplayKit

fileprivate let kImageSize = CGFloat(200.0)

// 디테일 뷰의 루트 노드
final class DetailRootNode: ASDisplayNode {
    var collectionNode: ASCollectionNode // 내부에 콜렉션을 가진다.

    private var imageCategory: String

    init(with imageCategory: String) {
        let layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout) // 초기화는 프레임 빠진 것 빼고는 UICollectionView와 동일하다.
        self.imageCategory = imageCategory

        super.init()

        // 노드 넣고 빼는 것을 자동으로 해줌 (addSubnode, removeSubnode가 필요없어짐)
        // layoutSpecThatFits: 메소드를 통해서 자동으로 처리해줌
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
    // 백그라운드 스레드에서 호출된다. 비싼 작업은 여기서 하면 된다.
    // 내부에서 layoutSpecBlock 호출은 하면 안된다.
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: self.collectionNode)
    }
}

extension DetailRootNode: ASCollectionDataSource, ASCollectionDelegate {
    // MARK :- ASCollectionDataSource
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    // 블록으로 넘기는 버전이 있고, 바로 셀을 만드는 버전이 있다.
    // 둘다 구현하면, 블록 버전이 우선적으로 호출된다.
    // 재사용 고려할 필요가 없다.
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let imageCategory = self.imageCategory
        return {
            let node = DetailCellNode()
            node.row = indexPath.row
            node.imageCategory = imageCategory
            return node
        }
    }

    // 셀 노드의 크기 범위 제약을 반환한다.
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let imageSize = CGSize(width: collectionNode.view.frame.width, height: kImageSize)

        return ASSizeRange(min: imageSize, max: imageSize)
    }
}
