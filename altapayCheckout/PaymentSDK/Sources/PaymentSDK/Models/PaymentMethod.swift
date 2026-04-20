//
//  PaymentMethod.swift
//  PaymentSDK
//

import Foundation

public struct PaymentMethod: Decodable, Identifiable {
    public let id: String
    public let type: String
    public let name: String
    public let description: String
    public let logoUrl: String?
    public let display: String
    public let onInitiatePayment: Action
    public let onRenderCheck: Action?
    //    let jsMethodHandler: JSMethodHandler?
    public let metadata: [String: String]
}

public struct Action: Decodable {
    public let type: String
    public let value: String?
}

public struct PaymentMethodsResponse: Decodable {
    public let methods: [PaymentMethod]
}

public struct PaymentInitiationRequest: Codable {
    public let paymentMethodId: String
    public let sessionId: String
    
    public init(paymentMethodId: String, sessionId: String) {
        self.paymentMethodId = paymentMethodId
        self.sessionId = sessionId
    }
}

public struct PaymentInitiationResponse: Decodable {
    public let paymentId: String
    public let shopOrderId: String
    public let status: String
    public let type: String
    public let url: String
}

public struct Configuration: Codable, Sendable {
    public let paymentType: String
    /// - Note:
    ///  `paymentDisplayType` must be set to `REDIRECT` for this functionality to work.
    public let paymentDisplayType: String = "REDIRECT"
    public let autoCapture: Bool
    public let country: String
    public let language: String
    
    public init(paymentType: String, autoCapture: Bool, country: String, language: String) {
        self.paymentType = paymentType
        self.autoCapture = autoCapture
        self.country = country
        self.language = language
    }
}

public struct ConfigurationResponse: Decodable, Sendable {
    public let paymentType: String
    public let paymentDisplayType: String
    public let autoCapture: Bool
    public let country: String
    public let language: String
}
