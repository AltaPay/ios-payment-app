//
//  CheckoutVM.swift
//  PaymentApp
//

import SwiftUI
import PaymentSDK

@Observable
final class CheckoutViewModel {

    private let client: PaymentClient

    var sessionId: String?
    var isLoading = false
    var error: String?

    init(client: PaymentClient) {
        self.client = client
    }

    func startCheckout() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let order = Order(
                orderId: "RonnieCheckoutAPITest",
                amount: .init(value: 2.0, currency: "DKK"),
                orderLines: [
                    .init(itemId: "123981239", description: "Chaos Emerald", quantity: 1, unitPrice: 1),
                    .init(itemId: "123981240", description: "Delivery", quantity: 1, unitPrice: 1)
                ],
                customer: Customer(
                    firstName: "John",
                    lastName: "Doe",
                    email: "test@example.com",
                    billingAddress: .init(
                        street: "Nygaardsvej 42",
                        city: "Copenhagen",
                        country: "DK",
                        zipCode: "1040"
                    ),
                    shippingAddress: .init(
                        street: "Nygaardsvej 42",
                        city: "Copenhagen",
                        country: "DK",
                        zipCode: "1040"
                    )
                ),
                transactionInfo: [
                    "additionalProp1": "Additional Payment information test 1",
                    "additionalProp2": "Additional Payment information test 2",
                    "additionalProp3": "Additional Payment information test 3"
                ]
            )
            
            let config = Configuration(
                paymentType: "PAYMENT",
                paymentDisplayType: "REDIRECT",
                bodyFormat: "JSON",
                autoCapture: false,
                country: "DK",
                language: "da"
            )

            let response = try await client.startCheckout(
                order: order,
                configuration: config
            )
            sessionId = response.sessionId

        } catch {
            self.error = error.localizedDescription
            print(error)
        }
    }
}
