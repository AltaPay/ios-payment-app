//
//  PaymentWebView.swift
//  PaymentSDK
//
//  Created for PaymentSDK
//

import SwiftUI
import WebKit
import Observation

// MARK: - Payment Result
public enum PaymentResult {
    case success(URL)
    case failure(Error)
    case cancelled
}

@MainActor
public final class NavigationDecider: NSObject, @unchecked Sendable {
    public let onResult: (PaymentResult) -> Void

    public init(onResult: @escaping (PaymentResult) -> Void) {
        self.onResult = onResult
        super.init()
    }

    public func handlePossibleRedirect(_ url: URL) -> Bool {
        let urlString = url.absoluteString.lowercased()
        let path = url.path.lowercased()
        let query = url.query?.lowercased() ?? ""

        if urlString.contains("success") ||
            urlString.contains("approved") ||
            path.contains("success") ||
            query.contains("status=success") ||
            query.contains("result=approved") {
            onResult(.success(url))
            return true
        }

        if urlString.contains("failure") ||
            urlString.contains("declined") ||
            urlString.contains("error") ||
            query.contains("status=failure") ||
            query.contains("error") {
            onResult(.failure(PaymentError.paymentDeclined))
            return true
        }

        if urlString.contains("cancel") ||
            query.contains("cancelled=true") ||
            path.contains("cancel") {
            onResult(.cancelled)
            return true
        }

        return false
    }
}

extension NavigationDecider: WebPage.NavigationDeciding {

    public func decidePolicy(for response: WebPage.NavigationResponse) async -> WKNavigationResponsePolicy {
        if let url = response.response.url {
            if handlePossibleRedirect(url) { return .allow }
        } else { return .cancel }
        return .allow
    }

}

public enum PaymentError: LocalizedError {
    case paymentDeclined
    case unknownRedirect
    case webViewError(Error)

    public var errorDescription: String? {
        switch self {
            case .paymentDeclined:      "Payment was declined or failed"
            case .unknownRedirect:      "Unknown payment redirect"
            case .webViewError(let error): error.localizedDescription
        }
    }
}
