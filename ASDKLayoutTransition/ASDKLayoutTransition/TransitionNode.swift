//
//  TransitionNode.swift
//  ASDKLayoutTransition
//
//  Created by Joshua on 2021/02/14.
//

import AsyncDisplayKit

fileprivate let USE_CUSTOM_LAYOUT_TRANSITION = true

final class TransitionNode: ASDisplayNode {
    var enabled: Bool = false
    var buttonNode: ASButtonNode = ASButtonNode()
    var textNodeOne: ASTextNode = ASTextNode()
    var textNodeTwo: ASTextNode = ASTextNode()

    override init() {
        super.init()

        self.automaticallyManagesSubnodes = true

        // 레이아웃 트랜지션의 애니메이션 동작 시간
        self.defaultLayoutTransitionDuration = 5.0

        self.textNodeOne.attributedText = NSAttributedString(string: """
            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled
    """)

        self.textNodeTwo.attributedText = NSAttributedString(string: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.")

        let title = "Start Layout Transition"
        let font = UIFont.systemFont(ofSize: 16)
        let color = UIColor.blue

        self.buttonNode.setTitle(title, with: font, with: color, for: .normal)
        self.buttonNode.setTitle(title, with: font, with: color.withAlphaComponent(0.5), for: .highlighted)

        self.textNodeOne.backgroundColor = .orange
        self.textNodeTwo.backgroundColor = .green
    }

    override func didLoad() {
        super.didLoad()

        self.buttonNode.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: .touchUpInside)
    }

    @objc func buttonPressed(_ sender: UIButton) {
        self.enabled.toggle()

        self.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nextTextNode = self.enabled ? self.textNodeTwo: self.textNodeOne

        // style은 크기 제약을 표현한다.
        // 최소 크기보다 작을 때, 얼마나 늘어나야 하는가?
        nextTextNode.style.flexGrow = 1.0
        // 최대 크기보다 클 때, 얼마나 늘어나야 하는가?
        nextTextNode.style.flexShrink = 1.0

        let horizontalStackLayout = ASStackLayoutSpec.horizontal()
        horizontalStackLayout.children = [nextTextNode]

        // 스택 내부에 있을 때, 이걸 어떻게 배치할 것인가?
        // 스택의 축에서의 교차축에서의 배치를 결정한다.
        self.buttonNode.style.alignSelf = .center

        let verticalStackLayout = ASStackLayoutSpec.vertical()
        verticalStackLayout.spacing = 10.0
        verticalStackLayout.children = [horizontalStackLayout, self.buttonNode]

        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0), child: verticalStackLayout)
    }


    // 커스텀 트랜지션 구현은 이렇게
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        guard USE_CUSTOM_LAYOUT_TRANSITION else { return }

        let fromNode = context.removedSubnodes()[0]
        let toNode = context.insertedSubnodes()[0]

        var buttonNode: ASButtonNode?

        for node in context.subnodes(forKey: ASTransitionContextToLayoutKey) {
            if let node = node as? ASButtonNode {
                buttonNode = node
                break
            }
        }

        var toNodeFrame = context.finalFrame(for: toNode)
        toNodeFrame.origin.x += (self.enabled ? toNodeFrame.size.width: toNodeFrame.size.width)
        toNode.frame = toNodeFrame
        toNode.alpha = 0.0

        var fromNodeFrame = fromNode.frame
        fromNodeFrame.origin.x = self.enabled ? -fromNodeFrame.size.width: fromNodeFrame.size.width

        UIView.animate(withDuration: self.defaultLayoutTransitionDuration,
                       animations: {
                        toNode.frame = context.finalFrame(for: toNode)
                        toNode.alpha = 1.0

                        fromNode.frame = fromNodeFrame
                        fromNode.alpha = 0.0

                        let fromSize = context.layout(forKey: ASTransitionContextFromLayoutKey)?.size
                        let toSize = context.layout(forKey: ASTransitionContextToLayoutKey)?.size

                        if fromSize != toSize {
                            let position = self.frame.origin

                            self.frame = CGRect(origin: position, size: toSize ?? .zero)
                        }

                        if let buttonNode = buttonNode {
                            buttonNode.frame = context.finalFrame(for: buttonNode)
                        }

                       }, completion: { finished in
                        context.completeTransition(finished)
                       })
    }
}
