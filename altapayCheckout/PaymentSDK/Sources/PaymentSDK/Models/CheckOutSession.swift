//
//  CheckoutSession.swift
//  PaymentSDK
//

import Foundation

public struct CheckoutSessionResponse: Decodable, Sendable {
    public let sessionId: String
    public let context: Context
    public let order: Order
    public let callbacks: Callbacks
    public let configuration: ConfigurationResponse
}

public struct Context: Decodable, Sendable {
    public let browser: Browser
}

public struct Browser: Decodable, Sendable {}
