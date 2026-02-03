# AltaPay iOS App

The project contains a set of examples of how to display our payment page in an iOS native app

## Merchant API
 
### Requirements

  The app requires following libraries/Pods to be installed:

  - pod `Alamofire`
  - pod `SwiftyJSON`

### Usage
 - Implement the required dependencies
 - Use `createPaymentRequest()` function in `CreatpaymentApiViewController` to call the Api.
 - Define Api method in `PaymentRequestManager` class.
 - To open a webView Create an instance of `WebURLHandler` class. 
 - To close the webView, handle the `WKNavigationDelegate` method in the `WebURLHandler` class.

    ![CodeSnippetMobile](docs/codesnippet-mobile.png)


## Checkout API

### Requirements

- iOS 16.0 or later
- Swift 5.9 or later
- Xcode 16.0 or later
- Valid PaymentSDK API credentials (username and password)
- Network access (HTTPS)

#### Swift Package Manager

Add the following to your `Package.swift` file or add the git url to Xcode dependencies

```swift
dependencies: [
    .package(url: "https://github.com/AltaPay/ios-payment-app.git")
]
```

Or add it through Xcode:
1. File → Add Packages...
2. Enter the repository URL
3. Select the version or branch

#### As an Added Framework

1. Clone this repository
2. Add `PaymentSDK` to your Xcode project

### 1. Initialize the SDK

In your app's initialization (e.g., `App` struct or `AppDelegate`):

```swift
// import the SDK
import PaymentSDK

/// Initialize the payment client with credentials.
/// - Parameters:
///   - username: API username
///   - password: API password
///   - baseURL: Base URL for the payment gateway (e.g., "https://testgateway.altapaysecure.com/")
/// public init(username: String, password: String, baseURL: URL)

let initalizedClient = PaymentClient(
    username: username,
    password: password,
    baseURL: baseURL
)
```

### 2. Create a Payment Session
Use the initalized client to create a session, the sessionID is used to show available payment methods

```swift
/// Creates a new checkout session.
/// - Parameters:
///   - order: Order details including items, customer, and amount
///   - callbacks: Callbacks details including redirect, success, and failure...
///   - configuration: Payment configuration (type, country, language, etc.)
/// - Returns: Checkout session response containing session ID
/// - Throws: `PaymentSDKError` if the operation fails
/// public func startCheckout(order: Order, callBacks: Callbacks, configuration: Configuration) async throws -> CheckoutSessionResponse

let order = Order(
    orderId: "OrderID-\(UUID().uuidString)",
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
    bodyFormat: "JSON",
    autoCapture: false,
    country: "DK",
    language: "da"
)

let callBackSuccess = Callback(type: "URL", value: "https://example.com")
let callBackFailure = Callback(type: "URL", value: "https://example.com")

let callbacks = Callbacks(
    success: callBackSuccess,
    failure: callBackFailure,
    redirect: "https://example.com",
    notification: "https://example.com"
)

let response = try await initalizedClient.startCheckout(
    order: order,
    callBacks: callbacks,
    configuration: config
)
let sessionId = response.sessionId
```

### 3. Fetch Payment Methods
Display fetched payment options for user to select

```swift
/// Fetches available payment methods for a checkout session.
/// - Parameter sessionId: The session ID from `startCheckout`
/// - Returns: Array of available payment methods
/// - Throws: `PaymentSDKError` if the operation fails
/// public func getPaymentMethods(sessionId: String) async throws -> [PaymentMethod]

let paymentMethods = try await initalizedClient.getPaymentMethods(sessionId: sessionId)
```

### 4. Initiate Payment
Initiates payment with the selected payment method.

```swift
/// - Parameters:
///   - methodId: ID of the selected payment method
///   - sessionId: The session ID from `startCheckout`
/// - Returns: Redirect URL for payment processing
/// - Throws: `PaymentSDKError` if the operation fails
/// public func initiatePayment(methodId: String, sessionId: String) async throws -> URL

let redirectURL = try await initalizedClient.initiatePayment(methodId: paymentMethods.id, sessionId: sessionId)
```

### 5. Display Payment WebView
use native webview to determine the callback through the redirectURL from step 4.

![CodeSnippetMobileCheckoutAPI](docs/Altapay-MobileApp-Checkout-Setup.svg)

### Models

- `Order` - Order details
- `Amount` - Monetary amount
- `OrderLine` - Order line item
- `Customer` - Customer information
- `Address` - Address information
- `PaymentMethod` - Payment method information
- `PaymentConfiguration` - Payment configuration
- `CheckoutSession` - Checkout session response

## Demo App

A complete demo app is included in the `PaymentApp` directory. To run it:

1. Update credentials in `PaymentApp/App/DemoApp.swift`
2. Build and run the demo app target

## Changelog

See [Changelog](CHANGELOG.md) for all the release notes.

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.