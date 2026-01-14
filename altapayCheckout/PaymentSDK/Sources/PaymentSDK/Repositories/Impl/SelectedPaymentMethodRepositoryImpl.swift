//
//  SelectedPaymentMethodRepositoryImpl.swift
//  PaymentApp
//

import Foundation

final class SelectedPaymentMethodRepositoryImpl: SelectedPaymentMethodRepository {

    private let api: APIClient
    private let baseURL: URL

    init(api: APIClient, baseURL: URL) {
        self.api = api
        self.baseURL = baseURL
    }

    func initiatePayment(
        paymentInitiationRequest: PaymentInitiationRequest,
        token: String
    ) async throws -> String {

        let response: PaymentInitiationResponse = try await api.request(
            SelectedPaymentMethodEndpoints.initiatePayment(
                baseURL: baseURL,
                body: paymentInitiationRequest,
                token: token
            )
        )

        return response.url
    }
}
