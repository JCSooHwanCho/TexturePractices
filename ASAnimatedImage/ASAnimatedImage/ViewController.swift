//
//  ViewController.swift
//  ASAnimatedImage
//
//  Created by Joshua on 2021/02/13.
//

import UIKit
import AsyncDisplayKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 이미지 다운로드를 자동으로 해주는 뷰 노드
        // 캐시와 다운로더를 기본으로 제공해주고, 필요하면 주입 가능
        let imageNode = ASNetworkImageNode()

        imageNode.url = URL(string: "https://i.pinimg.com/originals/07/44/38/074438e7c75034df2dcf37ba1057803e.gif")

        imageNode.frame = self.view.bounds

        imageNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageNode.contentMode = .scaleAspectFit

        self.view.addSubnode(imageNode)
    }
}

