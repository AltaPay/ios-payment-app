//
//  PaymentMethodsVM.swift
//  PaymentApp
//

import SwiftUI
import PaymentSDK

@Observable
final class PaymentMethodsViewModel {

    private let client: PaymentClient

    var methods: [PaymentMethod] = []
    var isLoading = false
    var error: String?

    init(client: PaymentClient) {
        self.client = client
    }

    func load(sessionId: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            methods = try await client.getPaymentMethods(sessionId: sessionId)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
