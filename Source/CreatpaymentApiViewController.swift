//
//  CreatpaymentApiViewController.swift
//  Payment-App-iOS
//

import UIKit
import SwiftyJSON
class CreatpaymentApiViewController: UIViewController {

    // Create an instance of PaymentApiManager
    let paymentApiManager = PaymentRequestManager()
    var webURLHandler: WebURLHandler?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func createPaymentRequest(){

        /*
         Set your GATEWAY URL
         for example: https://testgateway.altapaysecure.com/
         */
        paymentApiManager.setPaymentUrl(url:"GATEWAY URL")
        paymentApiManager.setAuthParam(user:"GATEWAY USER NAME", pass: "GATEWAY PASSWORD")
        /*
         prepare your paramter for payment request by following altapay documentation
         https://documentation.altapay.com/Content/Ecom/API/API%20Methods/createPaymentRequest.htm

         let configParameters: Parameters = [
             "callback_form": "Callback form URL",
             "callback_ok": "Callback ok URL",
             "callback_fail": "Callback fail URL",
             "callback_redirect": "Callback redirect URL",
             "callback_open": "Callback open URL",
             "callback_notification": "Callback notification URL"
         ]

         let Params: Parameters = [
             "type": "payment",
             "payment_source": "eCommerce",
             "terminal": "AltaPay Test Terminal",
             "shop_orderid": "123",
             "amount": 100,
             "currency": "DKK",
             "config": configParameters
         ]
         */

        let params: Parameters = [:] // Add your by following code snippet
        paymentApiManager.addParams(params: params )

        paymentApiManager.callPaymentApi{ xmlResponse, error in
            if let xmlResponse = xmlResponse {
                let json = JSON(xmlResponse)
                // HERE YOU CAN HANDLE YOUR JSON RESPONSE
                let payurl = json["Url"].stringValue
                self.webURLHandler = WebURLHandler(viewController: self, webUrl: payurl)
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
