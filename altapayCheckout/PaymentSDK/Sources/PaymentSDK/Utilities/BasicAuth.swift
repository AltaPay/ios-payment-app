//
//  BasicAuth.swift
//  PaymentApp
//

import Foundation

protocol CredentialStore: Sendable {
    var username: String { get }
    var password: String { get }
}

struct BasicAuth {

    static func header(username: String, password: String) -> String {
        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        return "Basic \(encoded)"
    }
}
