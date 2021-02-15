//
//  MapHandlerNode.swift
//  ASMapNode
//
//  Created by Joshua on 2021/02/14.
//

import AsyncDisplayKit

final class MapHandlerNode: ASDisplayNode {
    let latEditableNode = ASEditableTextNode()
    let lonEditableNode = ASEditableTextNode()
    let deltaLatEditableNode = ASEditableTextNode()
    let deltaLonEditableNode = ASEditableTextNode()
    let updateRegionButton = ASButtonNode()
    let liveMapToggleButton = ASButtonNode()
    let mapNode = ASMapNode()

    var liveMapStr: String {
        return mapNode.isLiveMap ? "Live Map is ON": "Live Map is Off"
    }

    override init() {
        super.init()

        self.automaticallyManagesSubnodes = true
        mapNode.mapDelegate = self

        let backgroundImage = UIImage.as_resizableRoundedImage(withCornerRadius: 5,
                                                               cornerColor: .white,
                                                               fill: .lightGray,
                                                               traitCollection: self.primitiveTraitCollection())
        let backgroundHighlightedImage = UIImage.as_resizableRoundedImage(withCornerRadius: 5,
                                                                          cornerColor: .white,
                                                                          fill: UIColor.lightGray.withAlphaComponent(0.4),
                                                                          borderColor: .lightGray,
                                                                          borderWidth: 2.0,
                                                                          traitCollection: self.primitiveTraitCollection())

        updateRegionButton.setBackgroundImage(backgroundImage, for: .normal)
        updateRegionButton.setBackgroundImage(backgroundHighlightedImage, for: .highlighted)

        liveMapToggleButton.setBackgroundImage(backgroundImage, for: .normal)
        liveMapToggleButton.setBackgroundImage(backgroundHighlightedImage, for: .highlighted)

        updateRegionButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        updateRegionButton.setTitle("Update Region", with: nil, with: .blue, for: .normal)
        updateRegionButton.addTarget(self, action: #selector(updateRegion), forControlEvents: .touchUpInside)

        liveMapToggleButton.setTitle(self.liveMapStr, with: nil, with: .blue, for: .normal)
        liveMapToggleButton.addTarget(self, action: #selector(toggleLiveMap), forControlEvents: .touchUpInside)
    }

    override func didLoad() {
        super.didLoad()

        self.configureEditableNodes(self.latEditableNode)
        self.configureEditableNodes(self.lonEditableNode)
        self.configureEditableNodes(self.deltaLatEditableNode)
        self.configureEditableNodes(self.deltaLonEditableNode)

        self.updateLocationTextWithMKCoordinatingRegion(mapNode.region)

        self.mapNode.imageForStaticMapAnnotationBlock = { annotation, centerOffsetPoint -> UIImage? in
            guard let annotation = annotation as? CustomMapAnnotation else { return nil }

            return annotation.image
        }

        self.addAnnotation()
    }
    /**
     * ------------------------------------ASStackLayoutSpec-----------------------------------
     * |  ---------------------------------ASInsetLayoutSpec--------------------------------  |
     * |  |  ------------------------------ASStackLayoutSpec-----------------------------  |  |
     * |  |  |  ---------------------------ASStackLayoutSpec--------------------------  |  |  |
     * |  |  |  |  -----------------ASStackLayoutSpec----------------                |  |  |  |
     * |  |  |  |  |  --------------ASStackLayoutSpec-------------  |                |  |  |  |
     * |  |  |  |  |  |  ASEditableTextNode  ASEditableTextNode  |  |                |  |  |  |
     * |  |  |  |  |  --------------------------------------------  |                |  |  |  |
     * |  |  |  |  |  --------------ASStackLayoutSpec-------------  |  ASButtonNode  |  |  |  |
     * |  |  |  |  |  |  ASEditableTextNode  ASEditableTextNode  |  |                |  |  |  |
     * |  |  |  |  |  --------------------------------------------  |                |  |  |  |
     * |  |  |  |  --------------------------------------------------                |  |  |  |
     * |  |  |  ----------------------------------------------------------------------  |  |  |
     * |  |  |                               ASButtonNode                               |  |  |
     * |  |  ----------------------------------------------------------------------------  |  |
     * |  ----------------------------------------------------------------------------------  |
     * |                                       ASMapNode                                      |
     * ----------------------------------------------------------------------------------------
     *
     *  This diagram was created by setting a breakpoint on the returned `layoutSpec`
     *  and calling "po [layoutSpec asciiArtString]" in the debugger.
     */

    // 스택 방식으로 레이아웃 구성
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacing = CGFloat(5)
        let height = CGFloat(30)

        // fraction은 비율이다. 100%가 1.0이다.
        // ASDimensionMake 함수를 쓰면 문자열로 %로 표기할 수 있다.
        let dimension = ASDimension(unit: .fraction, value: 0.5)
        self.latEditableNode.style.width = dimension
        self.lonEditableNode.style.width = dimension
        self.deltaLatEditableNode.style.width = dimension
        self.deltaLonEditableNode.style.width = dimension

        // 상수 제약
        liveMapToggleButton.style.maxHeight = ASDimension(unit: .points, value: height)

        mapNode.style.flexGrow = 1.0

        let lonlatSpec = ASStackLayoutSpec(direction: .horizontal,
                                           spacing: spacing,
                                           justifyContent: .start,
                                           alignItems: .center,
                                           children: [self.latEditableNode, self.lonEditableNode])
        let deltaLonlatSpec = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: spacing,
                                                justifyContent: .spaceBetween,
                                                alignItems: .center,
                                                children: [self.deltaLatEditableNode, self.deltaLonEditableNode])

        let lonlatConfigSpec = ASStackLayoutSpec(direction: .vertical,
                                                 spacing: spacing,
                                                 justifyContent: .start,
                                                 alignItems: .stretch,
                                                 children: [lonlatSpec, deltaLonlatSpec])

        lonlatConfigSpec.style.flexGrow = 1.0

        let dashboardSpec = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: spacing,
                                              justifyContent: .start,
                                              alignItems: .stretch,
                                              children: [lonlatConfigSpec, self.updateRegionButton])

        let headerVerticalStack = ASStackLayoutSpec(direction: .vertical,
                                                    spacing: spacing,
                                                    justifyContent: .start,
                                                    alignItems: .stretch,
                                                    children: [dashboardSpec, self.liveMapToggleButton])

        dashboardSpec.style.flexGrow = 1.0

        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10), child: headerVerticalStack)

        let layoutSpec = ASStackLayoutSpec(direction: .vertical,
                                           spacing: spacing,
                                           justifyContent: .start,
                                           alignItems: .stretch,
                                           children: [insetSpec, self.mapNode])

        return layoutSpec
    }

    @objc func updateRegion() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let lat = formatter.number(from: latEditableNode.attributedText?.string ?? "")?.doubleValue,
           let lon = formatter.number(from: lonEditableNode.attributedText?.string ?? "")?.doubleValue,
           let deltaLat = formatter.number(from: deltaLatEditableNode.attributedText?.string ?? "")?.doubleValue,
           let deltaLon = formatter.number(from: deltaLonEditableNode.attributedText?.string ?? "")?.doubleValue {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                            span: MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLon))

            self.mapNode.region = region
        }
    }

    @objc func toggleLiveMap() {
        mapNode.isLiveMap.toggle()
        let liveMapStr = self.liveMapStr

        liveMapToggleButton.setTitle(liveMapStr, with: nil, with: .blue, for: .normal)
        liveMapToggleButton.setTitle(liveMapStr, with: UIFont.systemFont(ofSize: 14), with: .blue, for: .highlighted)
    }

    private func configureEditableNodes(_ node: ASEditableTextNode) {
        node.returnKeyType = node == self.deltaLonEditableNode ? .done: .next
        node.delegate = self
    }

    private func updateLocationTextWithMKCoordinatingRegion(_ region: MKCoordinateRegion) {
        self.latEditableNode.attributedText = self.attributedStringFromFloat(CGFloat(region.center.latitude))
        self.lonEditableNode.attributedText = self.attributedStringFromFloat(CGFloat(region.center.longitude))
        self.deltaLatEditableNode.attributedText = self.attributedStringFromFloat(CGFloat(region.span.latitudeDelta))
        self.deltaLonEditableNode.attributedText = self.attributedStringFromFloat(CGFloat(region.span.longitudeDelta))
    }

    private func attributedStringFromFloat(_ value: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: String(format: "%0.3f", value))
    }

    private func annotationView(annotation: MKAnnotation) -> MKAnnotationView {
        let av: MKAnnotationView

        if let annotation = annotation as? CustomMapAnnotation {
            av = MKAnnotationView()
            av.centerOffset = CGPoint(x: 21, y: 21)
            av.image = annotation.image
        } else {
            av = MKPinAnnotationView(annotation: nil, reuseIdentifier: "")
        }

        av.isOpaque = false

        return av
    }

    private func addAnnotation() {
        let brno = MKPointAnnotation()
        brno.coordinate = CLLocationCoordinate2D(latitude: 49.2002211, longitude: 16.6078411)
        brno.title = "Brno City"

        let atlantic = CustomMapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 38.6442228, longitude: -29.9956942),
                                       image: UIImage(named: "Water"), // 이미지
                                       title: "Atlantic Ocean")
        let kilimanjaro = CustomMapAnnotation(coordinate: CLLocationCoordinate2D(latitude: -3.075833, longitude: 37.353333),
                                               image: UIImage(named: "Hill"),
                                               title: "Kilimanjaro")

        let mtblanc = CustomMapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 45.8325, longitude: 6.864444),
                                          image: UIImage(named: "Hill"),
                                          title: "Mont Blanc")

        self.mapNode.annotations = [brno, atlantic, kilimanjaro, mtblanc]
    }
}

extension MapHandlerNode: ASEditableTextNodeDelegate {
    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            switch editableTextNode {
            case self.latEditableNode:
                self.lonEditableNode.becomeFirstResponder()
            case self.lonEditableNode:
                self.deltaLatEditableNode.becomeFirstResponder()
            case self.deltaLatEditableNode:
                self.deltaLonEditableNode.becomeFirstResponder()
            case self.deltaLonEditableNode:
                self.deltaLonEditableNode.resignFirstResponder()
                self.updateRegion()
            default:
                break
            }

            return false
        }

        var characterSet = CharacterSet(charactersIn: ".-")
        characterSet.formUnion(.decimalDigits)
        characterSet.invert()

        guard text.rangeOfCharacter(from: characterSet) == nil else { return false }

        guard editableTextNode.attributedText?.string.range(of: ".") == nil || text.range(of: ".") == nil else { return false }

        guard editableTextNode.attributedText?.string .range(of: "-") == nil || text.range(of: "-") == nil || range.location == 0 else { return false }

        return true
    }
}

extension MapHandlerNode: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.updateLocationTextWithMKCoordinatingRegion(mapView.region)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return self.annotationView(annotation: annotation)
    }
}
