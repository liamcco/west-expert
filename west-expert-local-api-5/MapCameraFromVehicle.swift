//
//  MapCameraFromVehicle.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-17.
//

import MapKit
import SwiftUI

extension MapCamera {
    init?(vehicle: Components.Schemas.Positions_JourneyPositionApiModel) {
        guard let coordinate = CLLocationCoordinate2D(vehicle) else { return nil }
        self.init(centerCoordinate: coordinate, distance: 200, heading: 242, pitch: 60)
    }
}
