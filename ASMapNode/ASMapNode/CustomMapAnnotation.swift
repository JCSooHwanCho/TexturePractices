//
//  CustomMapAnnotation.swift
//  ASMapNode
//
//  Created by Joshua on 2021/02/14.
//

import Foundation
import MapKit

final class CustomMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var title: String?
    var subtitle: String?

    @objc internal init(coordinate: CLLocationCoordinate2D, image: UIImage? = nil, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
}
