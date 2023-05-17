//
//  ViewController.swift
//  Project4
//
//  Created by Ednan R. Frizzera Filho on 17/05/23.
//

import UIKit
import WebKit

// When we say A: B, C -> we are saying A inherits from B *and* promises it implements C.
// The order is *very* important. First comes the parent class (UIViewController in this case), then, all protocols implemented, separated by commas.
class ViewController: UIViewController, WKNavigationDelegate {

// MARK: - Properties
    var webView: WKWebView! // Used to store the web view itself.
    
    
// MARK: - Setup
    
    // loadView should be loaded *before* viewDidLoad()
    override func loadView() {
        webView = WKWebView()               // First, we created an instance of WKWebView and assigned it to the property we declared.
        webView.navigationDelegate = self   // Then we assigned the navigationDelegate property to self (the current View Controller).
        view = webView                      // Finally, we made the root view of the View Controller to be webView.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                                                                    // ATTENTION: we need to turn a string into a URL type to put in URLRequest!!!
        let url = URL(string: "https://www.hackingwithswift.com")!  // First, we create a new data type called URL,
        webView.load(URLRequest(url: url))                          // then we create a new URLRequest object from that URL and give it to web view to load.
        webView.allowsBackForwardNavigationGestures = true          // This line allows the gesture of swiping to move backwards and forward.
    }


}

