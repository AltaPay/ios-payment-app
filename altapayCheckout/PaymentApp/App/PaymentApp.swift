//
//  PaymentApp.swift
//

import SwiftUI
import PaymentSDK


let username = "demo@example.com"
let password = "userpass"
let baseURL = "https://testgateway.altapaysecure.com/"


@main
struct PaymentApp: App {

    private let client: PaymentClient
    private var cvm: CheckoutViewModel
    private var pvm: PaymentMethodsViewModel
    private var svm: SelectedPaymentMethodViewModel

    init() {
        
        guard let baseURL = URL(string: baseURL) else {
            fatalError("Invalid base URL: \(baseURL)")
        }
        
        self.client = PaymentClient(
            username: username,
            password: password,
            baseURL: baseURL
        )

        cvm = CheckoutViewModel(client: client)
        pvm = PaymentMethodsViewModel(client: client)
        svm = SelectedPaymentMethodViewModel(client: client)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(cvm: cvm, pvm: pvm, spvm: svm)
        }
    }
}
