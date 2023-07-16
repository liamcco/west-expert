//
//  TokenHandler.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-16.
//

import Foundation

class TokenHandler: @unchecked Sendable {
    private var token: String?
    
    let clientIdentifier = "eDNu9kAkTfUfFo5Bf7Wc50EJINYa"
    let clientSecret = "wWnyS_ElcW6SLaZhSHtHmsNffDYa"
    
    func getToken() async throws -> String {
        if let token {
            return token
        }
        return try await requestNewToken()
    }
    
    struct Token: Codable {
        let accessToken: String
        let scope: String
        let tokenType: String
        let expiresIn: Int
    }
    
    func requestNewToken() async throws -> String {
        print("Requesting new token")
        let authKey = "\(clientIdentifier):\(clientSecret)"
        guard let parsedData = authKey.data(using: .utf8) else {
            throw AuthError.parsingFailed
        }
        let encodedAuthKey = parsedData.base64EncodedString()
        
        guard let url = URL(string: "https://ext-api.vasttrafik.se/token") else {
            throw AuthError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic " + encodedAuthKey, forHTTPHeaderField: "Authorization")
        let bodyString = "grant_type=client_credentials"
        request.httpBody = bodyString.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw AuthError.tokenRefreshUnsuccessful
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let parsedResponse = try decoder.decode(Token.self, from: data)
            token = parsedResponse.accessToken
            return parsedResponse.accessToken
        } catch {
            throw AuthError.invalidData
        }
    }
}
