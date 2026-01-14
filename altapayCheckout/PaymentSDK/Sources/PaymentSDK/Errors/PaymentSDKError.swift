//
//  PaymentSDKError.swift
//  PaymentSDK
//
//  Created for PaymentSDK
//

import Foundation

/// Errors that can occur when using PaymentSDK
public enum PaymentSDKError: LocalizedError {
    case invalidConfiguration(String)
    case authenticationFailed(String)
    case networkError(Error)
    case invalidResponse
    case paymentInitiationFailed(String)
    case sessionCreationFailed(String)
    case paymentMethodsFetchFailed(String)
    case invalidURL(String)
    case paymentFailed(String)
    case missingSessionId
    
    public var errorDescription: String? {
        switch self {
        case .invalidConfiguration(let message):
            return "Invalid configuration: \(message)"
        case .authenticationFailed(let message):
            return "Authentication failed: \(message)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .paymentInitiationFailed(let message):
            return "Payment initiation failed: \(message)"
        case .sessionCreationFailed(let message):
            return "Session creation failed: \(message)"
        case .paymentMethodsFetchFailed(let message):
            return "Failed to fetch payment methods: \(message)"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .paymentFailed(let message):
            return "Payment failed: \(message)"
        case .missingSessionId:
            return "Session ID is required but was not provided"
        }
    }
}
