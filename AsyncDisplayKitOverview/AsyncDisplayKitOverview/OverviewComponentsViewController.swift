//
//  OverviewComponentsViewController.swift
//  AsyncDisplayKitOverview
//
//  Created by Joshua on 2021/02/15.
//

import AsyncDisplayKit

class OverviewComponentsViewController: ASDKViewController<ASTableNode> {

    let tableNode: ASTableNode
    let titles: [String] = ["Node Containers", "Nodes", "Layout Specs"]
    var datum: [[OverviewDisplayNodeWithSizeBlock]] = []

    override init() {
        self.tableNode = ASTableNode()

        super.init(node: self.tableNode)

        self.tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "AsyncDisplayKit"

        self.setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = self.tableNode.indexPathForSelectedRow {
            self.tableNode.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    
    @objc func buttonPressed(_ buttonNode: ASButtonNode) {
        print("Button Pressed")
    }

    private func setupData() {

        // MARK :- Container
        var nodesForContainerData: [OverviewDisplayNodeWithSizeBlock] = []

        nodesForContainerData.append(centeringParentNode(inset: .zero, child: OverviewASCollectionNode()))
        nodesForContainerData.last?.entryTitle = "ASCollectionNode"
        nodesForContainerData.last?.entryDescription = "ASCollectionNode is a node based class that wraps an ASCollectionView. It can be used as a subnode of another node, and provide room for many (great) features and improvements later on."

        nodesForContainerData.append(centeringParentNode(inset: .zero, child: OverviewASTableNode()))
        nodesForContainerData.last?.entryTitle = "ASTableNode"
        nodesForContainerData.last?.entryDescription = "ASTableNode is a node based class that wraps an ASTableView. It can be used as a subnode of another node, and provide room for many (great) features and improvements later on."

        nodesForContainerData.append(centeringParentNode(inset: .zero, child: OverviewASPagerNode()))
        nodesForContainerData.last?.entryTitle = "ASPagerNode"
        nodesForContainerData.last?.entryDescription = "ASPagerNode is a specialized subclass of ASCollectionNode. Using it allows you to produce a page style UI similar to what you'd create with a UIPageViewController with UIKit. Luckily, the API is quite a bit simpler than UIPageViewController's."

        // MARK :- Nodes
        var nodesData: [OverviewDisplayNodeWithSizeBlock] = []

        nodesData.append(centeringParentNode(with: childNode()))
        nodesData.last?.entryTitle = "ASDisplayNode"
        nodesData.last?.entryDescription = "ASDisplayNode is the main view abstraction over UIView and CALayer. It initializes and owns a UIView in the same way UIViews create and own their own backing CALayers."

        let buttonNode = ASButtonNode()
        buttonNode.setTitle("Button Title Normal", with: nil, with: .blue, for: .normal)
        buttonNode.setTitle("Button Title Highlighted",
                            with: UIFont.systemFont(ofSize: 14),
                            with: nil,
                            for: .highlighted)
        buttonNode.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: .touchUpInside)

        nodesData.append(centeringParentNode(with: buttonNode))
        nodesData.last?.entryTitle = "ASButtonNode"
        nodesData.last?.entryDescription = "ASButtonNode (a subclass of ASControlNode) supports simple buttons, with multiple states for a text label and an image with a few different layout options. Enables layerBacking for subnodes to significantly lighten main thread impact relative to UIButton (though async preparation is the bigger win)."

        let textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum varius nisi quis mattis dignissim. Proin convallis odio nec ipsum molestie, in porta quam viverra. Fusce ornare dapibus velit, nec malesuada mauris pretium vitae. Etiam malesuada ligula magna.")

        nodesData.append(centeringParentNode(with: textNode))
        nodesData.last?.entryTitle = "ASTextNode"
        nodesData.last?.entryDescription = "Like UITextView — built on TextKit with full-featured rich text support."

        let editableTextNode = ASEditableTextNode()
        editableTextNode.backgroundColor = .lightGray
        editableTextNode.attributedText = NSAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum varius nisi quis mattis dignissim. Proin convallis odio nec ipsum molestie, in porta quam viverra. Fusce ornare dapibus velit, nec malesuada mauris pretium vitae. Etiam malesuada ligula magna.")

        nodesData.append(centeringParentNode(with: editableTextNode))
        nodesData.last?.entryTitle = "ASEditableTextNode"
        nodesData.last?.entryDescription = "ASEditableTextNode provides a flexible, efficient, and animation-friendly editable text component."

        let imageNode = ASImageNode()
        imageNode.image = UIImage(named: "image")

        let imageNetworkImageNodeSize: CGSize

        if let image = imageNode.image {
            imageNetworkImageNodeSize = CGSize(width: image.size.width / 7,
                                                   height: image.size.height / 7)
            imageNode.style.preferredSize = imageNetworkImageNodeSize
        } else {
            imageNetworkImageNodeSize = .zero
        }

        nodesData.append(centeringParentNode(with: imageNode))
        nodesData.last?.entryTitle = "ASImageNode"
        nodesData.last?.entryDescription = "Like UIImageView — decodes images asynchronously."

        let networkImageNode = ASNetworkImageNode()
        networkImageNode.url = URL(string: "http://i.imgur.com/FjOR9kX.jpg")
        networkImageNode.style.preferredSize = imageNetworkImageNodeSize

        nodesData.append(centeringParentNode(with: networkImageNode))
        nodesData.last?.entryTitle = "ASNetworkImageNode"
        nodesData.last?.entryDescription = "ASNetworkImageNode is a simple image node that can download and display an image from the network, with support for a placeholder image."

        let mapNode = ASMapNode()
        mapNode.style.preferredSize = CGSize(width: 300, height: 300)

        let coord = CLLocationCoordinate2D(latitude: 37.7749,
                                                              longitude: -122.4194)
        mapNode.region = MKCoordinateRegion(center: coord,
                                            latitudinalMeters: 20000,
                                            longitudinalMeters: 20000)

        nodesData.append(centeringParentNode(with: mapNode))
        nodesData.last?.entryTitle = "ASMapNode"
        nodesData.last?.entryDescription = "ASMapNode offers completely asynchronous preparation, automatic preloading, and efficient memory handling. Its standard mode is a fully asynchronous snapshot, with liveMap mode loading automatically triggered by any ASTableView or ASCollectionView; its .liveMap mode can be flipped on with ease (even on a background thread) to provide a cached, fully interactive map when necessary."

        let scrollNode = ASScrollNode()
        let scrollNodeImage = UIImage(named: "image")

        scrollNode.style.preferredSize = CGSize(width: 300, height: 400)

        scrollNode.view.addSubview(UIImageView(image: scrollNodeImage))
        scrollNode.view.contentSize = scrollNodeImage?.size ?? .zero


        nodesData.append(centeringParentNode(with: scrollNode))
        nodesData.last?.entryTitle = "ASScrollNode"
        nodesData.last?.entryDescription = "Simple node that wraps UIScrollView."

        // MARK :- Layout Specs

        var layoutSpecData = [OverviewDisplayNodeWithSizeBlock]()

        var child = childNode()
        var parent = parentNode(with: child)

        parent.entryTitle = "ASInsetLayoutSpec"
        parent.entryDescription = "Applies an inset margin around a component."
        parent.sizeThatFitsBlock = { [child] _ in
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 0), child: child)
        }

        parent.addSubnode(child)
        layoutSpecData.append(parent)

        let backgroundNode = ASDisplayNode()
        backgroundNode.backgroundColor = .green

        child = childNode()
        child.backgroundColor = child.backgroundColor?.withAlphaComponent(0.5)

        parent = parentNode(with: child)
        parent.entryTitle = "ASBackgroundLayoutSpec"
        parent.entryDescription = "Lays out a component, stretching another component behind it as a backdrop."
        parent.sizeThatFitsBlock = { [child] _ in
            return ASBackgroundLayoutSpec(child: child, background: backgroundNode)
        }

        parent.addSubnode(backgroundNode)
        parent.addSubnode(child)

        layoutSpecData.append(parent)

        let overlayNode = ASDisplayNode()
        overlayNode.backgroundColor = UIColor.green.withAlphaComponent(0.5)

        child = childNode()

        parent = parentNode(with: child)
        parent.entryTitle = "ASOverlayLayoutSpec"
        parent.entryDescription = "Lays out a component, stretching another component on top of it as an overlay."
        parent.sizeThatFitsBlock = { [child] _ in
            return ASOverlayLayoutSpec(child: child, overlay: overlayNode)
        }

        parent.addSubnode(child)
        parent.addSubnode(overlayNode)

        layoutSpecData.append(parent)

        child = childNode()

        parent = parentNode(with: child)
        parent.entryTitle = "ASCenterLayoutSpec"
        parent.entryDescription = "Centers a component in the available space."
        parent.sizeThatFitsBlock = { [child] _ in
            return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: child)
        }

        parent.addSubnode(child)
        layoutSpecData.append(parent)

        // ASRatioLayoutSpec은 제대로 동작하는게 맞나 의심됨
        child = childNode()

        parent = parentNode(with: child)
        parent.entryTitle = "ASRatioLayoutSpec"
        parent.entryDescription = "Lays out a component at a fixed aspect ratio. Great for images, gifs and videos."
        parent.sizeThatFitsBlock = { [child] _ in
            return ASRatioLayoutSpec(ratio: 0.25, child: child)
        }
        parent.addSubnode(child)
        layoutSpecData.append(parent)


        child = childNode()

        parent = parentNode(with: child)
        parent.entryTitle = "ASRelativeLayoutSpec"
        parent.entryDescription = "Lays out a component and positions it within the layout bounds according to vertical and horizontal positional specifiers. Similar to the “9-part” image areas, a child can be positioned at any of the 4 corners, or the middle of any of the 4 edges, as well as the center."
        parent.sizeThatFitsBlock = { [child] _ in
            return ASRelativeLayoutSpec(horizontalPosition: .end,
                                        verticalPosition: .center,
                                        sizingOption: [],
                                        child: child)
        }

        parent.addSubnode(child)
        layoutSpecData.append(parent)

        child = childNode()
        // 레이아웃의 절대값을 제공한다.
        child.style.layoutPosition = CGPoint(x: 10, y: 10)

        parent = parentNode(with: child)
        parent.entryTitle = "ASAbsoluteLayoutSpec"
        parent.entryDescription = "Allows positioning children at fixed offsets."
        parent.sizeThatFitsBlock = { [child] _ in
            return ASAbsoluteLayoutSpec(children: [child])
        }
        parent.addSubnode(child)
        layoutSpecData.append(parent)

        var childNode1 = childNode()
        childNode1.backgroundColor = .green

        var childNode2 = childNode()
        childNode2.backgroundColor = .blue

        var childNode3 = childNode()
        childNode3.backgroundColor = .yellow

        // 스택 레이아웃에 추가된 뷰가 너무 커서 부모의 크기를 넘어가면, 특정 뷰를 줄여야 되는데, 이를 조절하기 위해 아래 두 뷰에 shrink값을 제공한다.
        childNode2.style.flexShrink = 1.0
        childNode3.style.flexShrink = 1.0

        parent = parentNode(with: child)
        parent.entryTitle = "Vertical ASStackLayoutSpec"
        parent.entryDescription = "Is based on a simplified version of CSS flexbox. It allows you to stack components vertically or horizontally and specify how they should be flexed and aligned to fit in the available space."
        parent.sizeThatFitsBlock = { [childNode1, childNode2, childNode3] _ in
            let verticalStackLayoutSpec = ASStackLayoutSpec.vertical()
            verticalStackLayoutSpec.alignItems = .start
            verticalStackLayoutSpec.children = [childNode1, childNode2, childNode3]
            return verticalStackLayoutSpec
        }

        parent.addSubnode(childNode1)
        parent.addSubnode(childNode2)
        parent.addSubnode(childNode3)

        layoutSpecData.append(parent)


        childNode1 = ASDisplayNode()
        childNode1.style.preferredSize = CGSize(width: 10, height: 20)
        childNode1.style.flexGrow = 1.0
        childNode1.backgroundColor = .green

        childNode2 = ASDisplayNode()
        childNode2.style.preferredSize = CGSize(width: 10, height: 20)
        childNode2.style.alignSelf = .stretch
        childNode2.backgroundColor = .blue

        childNode3 = ASDisplayNode()
        childNode3.style.preferredSize = CGSize(width: 10, height: 20)
        childNode3.backgroundColor = .yellow

        parent = parentNode(with: child)
        parent.entryTitle = "Horizontal ASStackLayoutSpec"
        parent.entryDescription = "Is based on a simplified version of CSS flexbox. It allows you to stack components vertically or horizontally and specify how they should be flexed and aligned to fit in the available space."
        parent.sizeThatFitsBlock = { [childNode1, childNode2, childNode3] _ in
            let horizontalStackSpec = ASStackLayoutSpec.horizontal()
            horizontalStackSpec.alignItems = .start
            horizontalStackSpec.children = [childNode1, childNode2, childNode3]
            horizontalStackSpec.spacing = 5.0

            horizontalStackSpec.style.height = ASDimension(unit: .fraction, value: 1.0)
            horizontalStackSpec.style.width = ASDimension(unit: .fraction, value: 1.0)

            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5), child: horizontalStackSpec)
        }

        parent.addSubnode(childNode1)
        parent.addSubnode(childNode2)
        parent.addSubnode(childNode3)

        layoutSpecData.append(parent)

        self.datum = [nodesForContainerData, nodesData, layoutSpecData]
    }

}

extension OverviewComponentsViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.datum.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titles[section]
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        self.datum[section].count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let node = self.datum[indexPath.section][indexPath.row]

        return {
            let cellNode = OverviewTitleDescriptionCellNode()

            let titleNodeAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ]

            if let entryTitle = node.entryTitle {
                cellNode.titleNode.attributedText = NSAttributedString(string: entryTitle,
                                                                       attributes: titleNodeAttributes)
            }

            if let entryDescription = node.entryDescription {
                let descriptionNodeAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.lightGray
                ]
                cellNode.descriptionNode.attributedText = NSAttributedString(string: entryDescription,
                                                                             attributes: descriptionNodeAttributes)

            }

            return cellNode
        }
    }
}

extension OverviewComponentsViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let node = self.datum[indexPath.section][indexPath.row]
        let detail = OverviewDetailViewController(with: node)
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

fileprivate func parentNode(with child: ASDisplayNode) -> OverviewDisplayNodeWithSizeBlock {
    let parentNode = OverviewDisplayNodeWithSizeBlock()
    parentNode.style.preferredSize = CGSize(width: 100, height: 100)
    parentNode.backgroundColor = .red

    return parentNode
}

fileprivate func centeringParentNode(with child: ASDisplayNode) -> OverviewDisplayNodeWithSizeBlock {
    return centeringParentNode(inset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: child)
}

fileprivate func centeringParentNode(inset: UIEdgeInsets, child:ASDisplayNode) -> OverviewDisplayNodeWithSizeBlock {
    let parentNode = OverviewDisplayNodeWithSizeBlock()
    parentNode.addSubnode(child)

    parentNode.sizeThatFitsBlock = { constraindSize in
        let centerLayoutSpec = ASCenterLayoutSpec(centeringOptions: .XY,
                                                  sizingOptions: [], child: child)
        return ASInsetLayoutSpec(insets: inset, child: centerLayoutSpec)
    }

    return parentNode
}

fileprivate func childNode() -> ASDisplayNode {
    let childNode = ASDisplayNode()
    childNode.style.preferredSize = CGSize(width: 50, height: 50)
    childNode.backgroundColor = .blue
    return childNode
}
