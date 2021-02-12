//
//  DetailCellNode.swift
//  TexturePractice
//
//  Created by Joshua on 2021/02/12.
//

import UIKit
import AsyncDisplayKit

final class DetailCellNode: ASCellNode {
    var row: Int?
    var imageCategory: String?
    var imageNode: ASNetworkImageNode {
        let imageNode = ASNetworkImageNode()
        imageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()

        return imageNode
    }

    var imageURL: URL? {
        let imageSize = self.calculatedSize

        guard let imageCategory = self.imageCategory,
              let row = self.row else { return nil }

        let imageURLString = String(format: "http://lorempixel.com/%ld/%ld/%@/%ld", Int(imageSize.width), Int(imageSize.height), imageCategory, row)

        return URL(string: imageURLString)
    }

    override init() {
        super.init()
    }

    // 다양한 layoutSpec이 있다. 이걸로 뭔가 레이아웃을 만드는 것 같은데...
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASRatioLayoutSpec(ratio: 1.0, child: self.imageNode)
    }

    // 레이아웃이 끝난 뒤 호출된다.
    // 메인 스레드에서 호출된다.
    override func layoutDidFinish() {
        super.layoutDidFinish()

        self.imageNode.url = self.imageURL
    }
}
