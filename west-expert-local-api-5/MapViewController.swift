//
//  MapViewController.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-16.
//

import Foundation

import OpenAPIRuntime
import OpenAPIURLSession
import SwiftUI
import MapKit

@Observable class MapViewController {
    var searchResults: [Components.Schemas.Positions_JourneyPositionApiModel] = []
    var activePolyline: [CLLocationCoordinate2D] = []
    
    let client: Client
    
    init() {
        self.client = Client(serverURL: try! Servers.server1(),
                             transport: URLSessionTransport(),
                             middlewares: [AuthenticationMiddleware()])
    }
    
    func select(_ selected: String) -> MapCameraPosition? {
        searchResults = searchResults.filter { result in
            result.detailsReference == selected
        }
        if let selectedVehicle = searchResults.first,
           let camera = MapCamera(vehicle: selectedVehicle) {
            return .camera(camera)
        } else {
            return nil
        }
    }
    
    func search(_ area: MKCoordinateRegion?) {
        guard let region = area else { return }
        
        activePolyline = []
        
        let lowerLeftLat = region.center.latitude - region.span.latitudeDelta/2
        let lowerLeftLong = region.center.longitude - region.span.longitudeDelta/2
        let upperRightLat = region.center.latitude + region.span.latitudeDelta/2
        let upperRightLong = region.center.longitude + region.span.longitudeDelta/2
        
        let input = Operations.getPositions.Input(query: Operations.getPositions.Input.Query(
            lowerLeftLat: lowerLeftLat,
            lowerLeftLong: lowerLeftLong,
            upperRightLat: upperRightLat,
            upperRightLong: upperRightLong,
            transportModes: [Components.Schemas.PositionTransportMode.tram]
        ))
        
        Task {
            let response = try await client.getPositions(input)
            
            switch response {
            case let .ok(okResponse):
                switch okResponse.body {
                case .json(let positions):
                    searchResults = positions
                }
            default:
                print("Some error")
            }
        }
    }
    
    func getDetails(for detailsReference: String) {
        // Required for map to update...
        // activePolyline = nil
        let includes: [Components.Schemas.JourneyDetailsIncludeType] = [.triplegcoordinates]
        
        let input = Operations.getJourneyDetails.Input(
            path: .init(detailsReference: detailsReference),
            query: Operations.getJourneyDetails.Input.Query(includes: includes))
        
        Task {
            let response = try await client.getJourneyDetails(input)
            
            switch response {
            case let .ok(okResponse):
                switch okResponse.body {
                case .json(let journeyDetails):
                    guard let triplegs = journeyDetails.tripLegs else {
                        // TODO: Handle error
                        return
                    }
                    
                    let newPolyline: [CLLocationCoordinate2D] = triplegs
                        .compactMap { $0.tripLegCoordinates }
                        .flatMap { $0 }
                        .map { coordinate in
                            return CLLocationCoordinate2D(coordinate: coordinate)
                        }
                        .compactMap { $0 }
                    activePolyline = newPolyline
                }
            default:
                // TODO: Handle error
                break
            }
        }
    }
}
