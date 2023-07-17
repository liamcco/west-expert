//
//  CLLocationCoordiateFromSchema.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-16.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    init?(coordinate: Components.Schemas.CoordinateApiModel) {
        guard let latitude = coordinate.latitude,
              let longitude = coordinate.longitude else {
            return nil
        }
        self.init(latitude: latitude, longitude: longitude)
    }
    
    init?(_ model: Components.Schemas.Positions_JourneyPositionApiModel) {
        guard let latitude = model.latitude, let longitude = model.longitude else { return nil }
        self.init(latitude: latitude, longitude: longitude)
    }
    
    init?(latitude: Double?, longitude: Double?) {
        guard let latitude, let longitude else { return nil }
        self.init(latitude: latitude, longitude: longitude)
    }
    
}
