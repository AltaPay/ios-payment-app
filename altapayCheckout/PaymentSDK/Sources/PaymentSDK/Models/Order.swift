//
//  Order.swift
//  PaymentApp
//

import Foundation

public struct CheckoutRequest: Codable, Sendable {
    public let order: Order
    public let callbacks: Callbacks
    public let configuration: Configuration
    public let isNativeFlow: Bool?
    public init(order: Order,
                callBacks: Callbacks,
                configuration: Configuration,
                isNativeFlow: Bool? = nil) {
        self.order = order
        self.callbacks = callBacks
        self.configuration = configuration
        self.isNativeFlow = isNativeFlow
    }
}

public struct Order: Codable, Sendable {
    public let orderId: String
    public let amount: Amount
    public let orderLines: [OrderLine]
    public let customer: Customer
    public let transactionInfo: [String: String]
    
    public init(orderId: String, amount: Amount, orderLines: [OrderLine], customer: Customer, transactionInfo: [String : String]) {
        self.orderId = orderId
        self.amount = amount
        self.orderLines = orderLines
        self.customer = customer
        self.transactionInfo = transactionInfo
    }
}

public struct Amount: Codable, Sendable {
    public let value: Double
    public let currency: String
    
    public init(value: Double, currency: String) {
        self.value = value
        self.currency = currency
    }
}

public struct OrderLine: Codable, Sendable {
    public let itemId: String
    public let description: String
    public let quantity: Int
    public let unitPrice: Double
    
    public init(itemId: String, description: String, quantity: Int, unitPrice: Double) {
        self.itemId = itemId
        self.description = description
        self.quantity = quantity
        self.unitPrice = unitPrice
    }
}

public struct Customer: Codable, Sendable {
    public let firstName: String
    public let lastName: String
    public let email: String
    public let billingAddress: Address
    public let shippingAddress: Address
    
    public init(firstName: String, lastName: String, email: String, billingAddress: Address, shippingAddress: Address) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
    }
}

public struct Address: Codable, Sendable {
    public let street: String
    public let city: String
    public let country: String
    public let zipCode: String
    
    public init(street: String, city: String, country: String, zipCode: String) {
        self.street = street
        self.city = city
        self.country = country
        self.zipCode = zipCode
    }
}

public struct Callbacks: Codable, Sendable {
    public let success: Callback
    public let failure: Callback
    public let redirect: String
    public let notification: String
    public let bodyFormat: String

    public init(
        success: Callback,
        failure: Callback,
        redirect: String,
        notification: String,
        bodyFormat: String
    ) {
        self.success = success
        self.failure = failure
        self.redirect = redirect
        self.notification = notification
        self.bodyFormat = bodyFormat
    }
}

public struct Callback: Codable, Sendable {
    public let type: String
    public let value: String

    public init(type: String, value: String) {
        self.type = type
        self.value = value
    }
}
