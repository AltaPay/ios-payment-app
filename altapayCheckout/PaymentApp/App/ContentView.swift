//
//  ContentView.swift
//  PaymentApp
//

import SwiftUI
import Observation
import PaymentSDK
import WebKit

struct ContentView: View {

    @State var cvm: CheckoutViewModel
    @State var pvm: PaymentMethodsViewModel
    @State var spvm: SelectedPaymentMethodViewModel
    @State private var showPaymentWebView = false
    @State private var paymentURL: URL?
    @State private var page: WebPage = {
        var config = NavigationDecider { result in
            switch result {
                case .success(let url):
                    print("Payment successful: \(url)")
                    // Handle success - you might want to show an alert or navigate
                case .failure(let error):
                    print("Payment failed: \(error.localizedDescription)")
                    // Handle failure - show error to user
                case .cancelled:
                    print("Payment cancelled")
                    // Handle cancellation
            }
        }
        return WebPage(navigationDecider: config)
    }()

    var body: some View {
        NavigationStack {
            Group {
                if cvm.isLoading {
                    ProgressView("Creating checkout session...")
                } else if let error = cvm.error {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Error")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await cvm.startCheckout()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if pvm.isLoading {
                    ProgressView("Loading payment methods...")
                } else if let error = pvm.error {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Error")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            if let sessionId = cvm.sessionId {
                                Task {
                                    await pvm.load(sessionId: sessionId)
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if pvm.methods.isEmpty {
                    Text("No payment methods available")
                        .foregroundColor(.secondary)
                } else {
                    List(pvm.methods) { method in
                        Button {
                            Task {
                                await spvm.onMethodSelected(
                                    method: method,
                                    sessionId: cvm.sessionId ?? ""
                                )
                                if let url = spvm.redirectURL {
                                    paymentURL = url
                                    showPaymentWebView = true
                                }
                            }
                        } label: {
                            row(method)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Payment Methods")
        }
        .sheet(isPresented: $showPaymentWebView) {
            if let url = spvm.redirectURL {
                NavigationStack {
                    WebView(page)
                        .onAppear {
                            page.load(url)
                    }
                    .navigationTitle("Payment")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Close") {
                                showPaymentWebView = false
                                paymentURL = nil
                                spvm.redirectURL = nil
                            }
                        }
                    }
                }
            }
        }
        .task {
            await cvm.startCheckout()
            if let sessionId = cvm.sessionId {
                await pvm.load(sessionId: sessionId)
            }
        }
    }
}

@ViewBuilder
private func row(_ method: PaymentMethod) -> some View {
    HStack(spacing: 12) {

        if let logo = method.logoUrl,
           let url = URL(string: logo),
           !logo.contains("null") {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
        }

        VStack(alignment: .leading) {
            Text(method.name)
                .font(.headline)

            Text(method.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }

        Spacer()

        Text(method.type)
            .font(.caption)
    }
}


#Preview {
    // Preview with mock client - replace with your test credentials
    let client = PaymentClient(
        username: username,
        password: password,
        baseURL: URL(string: baseURLString)!
    )
    
    let cvm = CheckoutViewModel(client: client)
    let pvm = PaymentMethodsViewModel(client: client)
    let svm = SelectedPaymentMethodViewModel(client: client)
    
    return ContentView(cvm: cvm, pvm: pvm, spvm: svm)
}
