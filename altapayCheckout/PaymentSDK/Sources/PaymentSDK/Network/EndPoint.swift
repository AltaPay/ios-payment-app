//
//  EndPoint.swift
//  PaymentApp
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Endpoint {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
}

enum APIConstants {
    static let version = "v1"
    
    static func path(for baseURL: URL) -> String {
        let urlString = baseURL.absoluteString
        // Ensure trailing slash
        let base = urlString.hasSuffix("/") ? urlString : urlString + "/"
        return base + "checkout/\(version)/api"
    }
}

enum AuthEndpoints {
    static func authenticate(
        baseURL: URL,
        authorization: String
    ) -> Endpoint {
        Endpoint(
            url: URL(string: APIConstants.path(for: baseURL) + "/authenticate")!,
            method: .post,
            headers: [
                "Authorization": authorization
            ],
            body: nil
        )
    }
}

enum CheckoutEndpoints {
    
    static func createSession(
        baseURL: URL,
        body: CheckoutRequest,
        authorization: String
    ) -> Endpoint {
        
        Endpoint(
            url: URL(string: APIConstants.path(for: baseURL) + "/session")!,
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": authorization
            ],
            body: try? JSONEncoder().encode(body)
        )
    }
}

enum PaymentMethodEndpoints {
    
    static func list(
        baseURL: URL,
        sessionId: String,
        token: String
    ) -> Endpoint {
        
        Endpoint(
            url: URL(
                string: APIConstants.path(for: baseURL) + "/session/\(sessionId)/payment-methods"
            )!,
            method: .get,
            headers: [
                "Authorization": "Bearer \(token)"
            ],
            body: nil
        )
    }
}

enum SelectedPaymentMethodEndpoints {
    
    static func initiatePayment(
        baseURL: URL,
        body: PaymentInitiationRequest,
        token: String
    ) -> Endpoint {
        
        Endpoint(
            url: URL(
                string: APIConstants.path(for: baseURL) + "/payment"
            )!,
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ],
            body: try? JSONEncoder().encode(body)
        )
    }
}
