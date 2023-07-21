//
//  AuthenticationMiddleware.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-16.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

/// Injects an authorization header to every request.
struct AuthenticationMiddleware: ClientMiddleware {
    
    let tokenHandler = TokenHandler()
    
    func intercept(
        _ request: Request,
        baseURL: URL,
        operationID: String,
        next: (Request, URL) async throws -> Response
    ) async throws -> Response {
        var request = request
        let healthyToken = try await tokenHandler.getToken()
        
        request.headerFields.append(.init(
            name: "Authorization", value: "Bearer \(healthyToken)"
        ))
        let response = try await next(request, baseURL)
        
        guard response.statusCode == 401 else {
            return response
        }
        
        // TODO: Implement OAuth2 code
        let newToken = try await tokenHandler.requestNewToken()
        request.headerFields.removeAll { headerField in
            headerField.name == "Authorization"
        }
        request.headerFields.append(.init(
            name: "Authorization", value: "Bearer \(newToken)"
        ))
        
        let responseAfterRefresh = try await next(request, baseURL)
        
        guard responseAfterRefresh.statusCode == 401 else {
            return response
        }
        
        throw AuthError.fatalTokenFailure
    
    }
}
