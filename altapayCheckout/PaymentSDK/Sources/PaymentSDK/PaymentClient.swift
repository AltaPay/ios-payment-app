//
//  PaymentClient.swift
//  PaymentSDK
//

import Foundation

/// Main client for payment operations.
/// All methods are thread-safe and can be called from any thread.
public actor PaymentClient {
    private let api: APIClient
    private let authRepo: AuthRepository
    private let checkoutRepo: CheckoutRepository
    private let paymentMethodRepo: PaymentMethodRepository
    private let selectedPaymentMethodRepo: SelectedPaymentMethodRepository
    
    private var token: String?
    
    /// Initialize the payment client with credentials.
    /// - Parameters:
    ///   - username: API username
    ///   - password: API password
    ///   - baseURL: Base URL for the payment gateway (e.g., "https://gateway.altapaysecure.com/")
    public init(username: String, password: String, baseURL: URL) {
        self.api = URLSessionAPIClient()
        
        struct SDKCredentialStore: CredentialStore {
            let username: String
            let password: String
        }
        let creds = SDKCredentialStore(username: username, password: password)
        
        self.authRepo = AuthRepositoryImpl(api: api, credentialStore: creds, baseURL: baseURL)
        self.checkoutRepo = CheckoutRepositoryImpl(api: api, baseURL: baseURL)
        self.paymentMethodRepo = PaymentMethodRepositoryImpl(api: api, baseURL: baseURL)
        self.selectedPaymentMethodRepo = SelectedPaymentMethodRepositoryImpl(api: api, baseURL: baseURL)
    }
    
    private func ensureToken() async throws -> String {
        if let token = token { return token }
        let response = try await authRepo.authenticate()
        self.token = response.token
        return response.token
    }
    
    /// Creates a new checkout session.
    /// - Parameters:
    ///   - order: Order details including items, customer, and amount
    ///   - callbacks: Callbacks details including success, failure, and redirect...
    ///   - configuration: Payment configuration (type, country, language, etc.)
    ///   - isNativeFlow: true selects the Native App Flow, where Checkout redirects straight into
    ///     the payment method's app instead of rendering a payment page. Defaults to false/unset (Web-Based Flow).
    /// - Returns: Checkout session response containing session ID
    /// - Throws: `PaymentSDKError` if the operation fails
    public func startCheckout(order: Order, callBacks: Callbacks, configuration: Configuration, isNativeFlow: Bool? = nil) async throws -> CheckoutSessionResponse {
        let token = try await ensureToken()
        let request = CheckoutRequest(order: order, callBacks: callBacks, configuration: configuration, isNativeFlow: isNativeFlow)
        return try await Task.detached {
                try await self.checkoutRepo.createSession(request: request, token: token)
            } .value
    }
    
    /// Fetches available payment methods for a checkout session.
    /// - Parameter sessionId: The session ID from `startCheckout`
    /// - Returns: Array of available payment methods
    /// - Throws: `PaymentSDKError` if the operation fails
    public func getPaymentMethods(sessionId: String) async throws -> [PaymentMethod] {
        let token = try await ensureToken()
        return try await paymentMethodRepo.fetchMethods(sessionId: sessionId, token: token)
    }
    
    /// Initiates payment with the selected payment method.
    /// - Parameters:
    ///   - methodId: ID of the selected payment method
    ///   - sessionId: The session ID from `startCheckout`
    /// - Returns: Redirect URL for payment processing
    /// - Throws: `PaymentSDKError` if the operation fails
    public func initiatePayment(methodId: String, sessionId: String) async throws -> URL {
        let token = try await ensureToken()
        let req = PaymentInitiationRequest(paymentMethodId: methodId, sessionId: sessionId)
        let urlString = try await selectedPaymentMethodRepo.initiatePayment(paymentInitiationRequest: req, token: token)
        guard let url = URL(string: urlString) else {
            throw PaymentSDKError.invalidURL(urlString)
        }
        return url
    }
}
