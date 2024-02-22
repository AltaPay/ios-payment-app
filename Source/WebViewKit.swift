//
//  WebView.swift
//  Payment-App-iOS
//

import Foundation
import UIKit
import WebKit

// This class is responsible to load your URl in Webkit
class WebURLHandler: NSObject, WKNavigationDelegate {
    private var webView: WKWebView?
    private var viewController: UIViewController?
    private var webUrl: String?

    init(viewController: UIViewController, webUrl: String) {
        super.init()
        self.viewController = viewController
        self.webUrl = webUrl
        setupWebView()
    }

    private func setupWebView() {
        // Create a WKWebView
        let webViewFrame = CGRect(x: 0, y: 0, width: viewController?.view.frame.width ?? 0, height: viewController?.view.frame.height ?? 0)
        webView = WKWebView(frame: webViewFrame)
        webView?.navigationDelegate = self

        // Add the WKWebView to the view hierarchy
        viewController?.view.addSubview(webView!)

        // Load a URL
        if let url = URL(string: webUrl ?? "") {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }

    func dismissWebView() {
        webView?.removeFromSuperview()
        webView = nil
    }

    //Implement WKNavigationDelegate methods if needed
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Hnadle your weburl here
        if webView.url?.absoluteString != webUrl{
            dismissWebView()
        }
    }
}
