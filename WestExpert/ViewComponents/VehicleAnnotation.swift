//
//  VehicleAnnotation.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-17.
//

import SwiftUI
import MapKit

struct VehicleAnnotation: MapContent {
    
    let coordinate: CLLocationCoordinate2D
    let detailsReference: String
    let name: String
    let markerView: VehicleMarker
    
    var body: some MapContent {
        Annotation(name, coordinate: coordinate) {
            markerView
        }
        .tag(detailsReference)
        .annotationTitles(.hidden)
    }
        
    init?(_ result: Components.Schemas.Positions_JourneyPositionApiModel) {
        guard let coordinate = CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude),
              let detailsReference = result.detailsReference,
              let name = result.line?.name,
              let markerView = VehicleMarker(result) else {
                return nil
        }
        
        self.coordinate = coordinate
        self.detailsReference = detailsReference
        self.name = name
        self.markerView = markerView
    }
}
