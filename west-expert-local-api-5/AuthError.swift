//
//  AuthError.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-16.
//

import Foundation

enum AuthError: Error {
    case parsingFailed
    case badURL
    case tokenRefreshUnsuccessful
    case invalidData
    case fatalTokenFailure
}
