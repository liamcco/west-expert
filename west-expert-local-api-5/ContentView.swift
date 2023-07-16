//
//  ContentView.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-16.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Get Details")
        }
        .padding()
        .task {
            do {
                try await makeRequest()
            } catch {
                print("Error")
            }
        }
    }
    
    let client: Client
    
    init() {
        self.client = Client(serverURL: try! Servers.server1(),
                             transport: URLSessionTransport(),
                             middlewares: [AuthenticationMiddleware()])
    }
    
    func makeRequest() async throws {
        let input = Operations.getJourneyDetails.Input(path: .init(detailsReference: "V3eyJUIjpbeyJSIjoiMXw0NTY1M3wwfDgwfDE2MDcyMDIzIiwiSSI6MH1dfQ"))
        let response = try await client.getJourneyDetails(input)
        
        switch response {
        case .ok(_):
            print("OK response")
        case .badRequest(_):
            print("Bad request")
        case .notFound(_):
            print("Not found")
        case .internalServerError(_):
            print("internal server error")
        case .serviceUnavailable(_):
            print("service unreachable")
        case .undocumented(statusCode: let statusCode, _):
            print("undocumented response: \(statusCode)")
        }
    }
}

#Preview {
    ContentView()
}
