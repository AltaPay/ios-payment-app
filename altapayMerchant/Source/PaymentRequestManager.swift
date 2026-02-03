//
//  PaymentRequestManager.swift
//  Payment-App-iOS
//

import UIKit
import Alamofire

class PaymentRequestManager: NSObject , XMLParserDelegate{
    private var currentElement: String?
    private var parsedData = [String: Any]()
    private var PaymentURL:String?
    private var baseURL:String = ""
    private let method: HTTPMethod = .post
    private var username:String = ""
    private var password:String = ""
    var parameters: Parameters = [:]

    func callPaymentApi(completion: @escaping (Data?, Error?) -> Void)  {

        let credentialsData = "\(username):\(password)".data(using: .utf8)!
        let base64Credentials = credentialsData.base64EncodedString()

        // Create the Authorization header
        let headers: HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]

        // Make the Alamofire request with basic authentication and URL encoding
        AF.request(baseURL, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseString { response in
                // Handle the response here
                switch response.result {
                case .success(let value):
                    let xmlData = Data(value.utf8)
                    let jsonData = self.convertXMLtoJSON(xmlData:xmlData )
                    DispatchQueue.main.async {
                        completion(jsonData, nil)
                    }
                    return
                case .failure(let error):
                    print("Error: \(error)")
                    completion(nil, error)
                }
            }
    }

    func setPaymentUrl(url:String){
        baseURL = url
    }

    func setAuthParam(user:String,pass:String){
        username = user
        password = pass
    }

    func addParams(params:Parameters){
        parameters = params
    }

    func convertXMLtoJSON(xmlData: Data) -> Data? {
        let xmlParser = XMLParser(data: xmlData)
        xmlParser.delegate = self
        if xmlParser.parse() {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parsedData, options: .prettyPrinted)
                return jsonData
            } catch {
                print("Error converting to JSON: \(error)")
                return nil
            }
        } else {
            print("XML parsing failed")
            return nil
        }
    }

    // MARK: - XMLParserDelegate

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let currentElement = currentElement {
            parsedData[currentElement] = string
        }
    }
}
