//
//  PaymentMethodRepository.swift
//  PaymentApp
//

protocol PaymentMethodRepository: Sendable {
    func fetchMethods(sessionId: String, token: String) async throws -> [PaymentMethod]
}
