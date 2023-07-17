//
//  ContentView.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-16.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession
import MapKit

struct VehicleMapView: View {
    
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var selected: String? = nil
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @Environment(MapViewController.self) var mapViewController
    
    var body: some View {
        NavigationStack {
            Map(position: $position, bounds: .gothenburgBounds, selection: $selected) {
                
                // TODO: This does not refresh automatically
                if !mapViewController.activePolyline.isEmpty {
                    MapPolyline(coordinates: mapViewController.activePolyline)
                        .stroke(.blue, lineWidth: 5)
                }
                
                ForEach(mapViewController.searchResults, id: \.self) { result in
                    if let annotation = VehicleAnnotation(result) {
                        annotation
                    }
                }
                
            }
            .mapStyle(.imagery(elevation: .realistic))
            
            .safeAreaInset(edge: .bottom) {
                MapToolbar(searching: visibleRegion)
            }
            .onChange(of: selected) {
                if let selected {
                    if let newCameraposition = mapViewController.select(selected) {
                        withAnimation { position = newCameraposition }
                    }
                    mapViewController.getDetails(for: selected)
                }
            }
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
        }
    }
}

#Preview {
    VehicleMapView(position: .automatic)
}
