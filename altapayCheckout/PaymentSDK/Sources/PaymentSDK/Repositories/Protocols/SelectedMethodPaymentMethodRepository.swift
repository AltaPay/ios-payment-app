//
//  SelectedPaymentMethodRepository.swift
//  PaymentApp
//

protocol SelectedPaymentMethodRepository: Sendable {
    func initiatePayment(
        paymentInitiationRequest: PaymentInitiationRequest,
        token: String
    ) async throws -> String
}

