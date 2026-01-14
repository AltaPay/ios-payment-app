//
//  PaymentApp.swift
//

import SwiftUI
import PaymentSDK


let username = "ij@technologies.dk"
let password = "6#Nf2XE#wwAvAN4qL"
let baseURLString = "https://testgateway.altapaysecure.com/"


@main
struct PaymentApp: App {

    private let client: PaymentClient
    private var cvm: CheckoutViewModel
    private var pvm: PaymentMethodsViewModel
    private var svm: SelectedPaymentMethodViewModel

    init() {
        
        guard let baseURL = URL(string: baseURLString) else {
            fatalError("Invalid base URL: \(baseURLString)")
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
