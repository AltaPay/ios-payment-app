//
//  PaymentMethodRepositoryImpl.swift
//  PaymentApp
//

import Foundation

final class PaymentMethodRepositoryImpl: PaymentMethodRepository {

    private let api: APIClient
    private let baseURL: URL

    init(api: APIClient, baseURL: URL) {
        self.api = api
        self.baseURL = baseURL
    }

    func fetchMethods(sessionId: String, token: String) async throws -> [PaymentMethod] {

        let response: PaymentMethodsResponse = try await api.request(
            PaymentMethodEndpoints.list(
                baseURL: baseURL,
                sessionId: sessionId,
                token: token
            )
        )

        return response.methods
    }
}
