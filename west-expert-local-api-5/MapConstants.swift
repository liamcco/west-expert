//
//  CLLocationCoordinate2DConst.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-17.
//

import MapKit
import SwiftUI

extension CLLocationCoordinate2D {
    static let gothenburg = CLLocationCoordinate2D(latitude: 57.6987, longitude: 11.9698)
}

extension MapCameraBounds {
    static let gothenburgBounds = MapCameraBounds(centerCoordinateBounds: .gothenburgRegion, maximumDistance: 100_000)
}

extension MapCameraPosition {
    static let gothenburgCameraPosition: MapCameraPosition = .region(.gothenburgRegion)
}
    
extension MKCoordinateRegion {
    static let gothenburgRegion = MKCoordinateRegion(center: .gothenburg, latitudinalMeters: 15_000, longitudinalMeters: 15_000)
}
