//
//  west_expert_local_api_5App.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-16.
//

import SwiftUI

@main
struct west_expert_local_api_5App: App {
    var body: some Scene {
        WindowGroup {
            VehicleMapView()
                .environment(MapViewController())
        }
    }
}
