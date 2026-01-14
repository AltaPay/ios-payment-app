//
//  CheckOutRepository.swift
//  PaymentApp
//

protocol CheckoutRepository: Sendable {
    func createSession(request: CheckoutRequest, token: String) async throws -> CheckoutSessionResponse
}
