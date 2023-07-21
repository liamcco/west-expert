//
//  SwiftUIView.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-17.
//

import SwiftUI
import MapKit

struct MapToolbar: View {
    
    @Environment(MapViewController.self) var mapViewController
    let visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: { mapViewController.search(visibleRegion) }) {
                Text("Search")
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Spacer()
        }
        .background(.thinMaterial)
    }
    
    init(searching visibleRegion: MKCoordinateRegion?) {
        self.visibleRegion = visibleRegion
    }
}

#Preview {
    MapToolbar(searching: nil)
}
