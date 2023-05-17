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
    
    var webView: WKWebView!     // Used to store the web view itself.
    var progressView: UIProgressView!       // Necessary to keep track of the loading progress.
    var websites = ["apple.com", "hackingwithswift.com", "google.com"]
    
    
    // MARK: - Setup
    
    // loadView should be loaded *before* viewDidLoad()
    override func loadView() {			        // ATTENTION: to conform to navigationDelegate, it has to be added above as an implemented protocol in "class"!!!
        webView = WKWebView()                   // First, we created an instance of WKWebView and assigned it to the property we declared.
        webView.navigationDelegate = self       // Then we assigned the navigationDelegate property to self (the current view controller).
        view = webView                          // Finally, we made the root view of the view controller to be webView.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix for the overlapping content with clock/battery/signal!!
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        
        // First page when starting the app                               // ATTENTION: we need to turn a string into a URL type to put in URLRequest!!!
        let url = URL(string: "https://" + websites[0])!        // First, we create a new data type called URL,
        webView.load(URLRequest(url: url))                      // then we create a new URLRequest object from that URL and give it to web view to load.
        
        // This allows the gesture of swiping to move backwards and forward.
        webView.allowsBackForwardNavigationGestures = true
        
        // Navigation bar button to open the website list.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // Progress bar setup
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)       // Observer to inform the progress.
        
        progressView = UIProgressView(progressViewStyle: .default)      // Creates a new UIProgressView instance, and
        progressView.sizeToFit()                                        // sets the bar's size.
        
        // Bottom bar configuration and buttons
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)     // Can't be tapped, so it doesn't need target and action.
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))       // Calls the reload() method.
        let progressBar = UIBarButtonItem(customView: progressView)     // Wraps the UIProgressView in a UIBarButtonItem to be inserted in the toolbar
        
        toolbarItems = [spacer, progressBar, spacer, refresh]        // Toolbar associated with the view controller.
        navigationController?.isToolbarHidden = false       // Forces showing the toolbar.
    }
    
    
// MARK: - Functions
    
    // Action required for the rightBarButtonItem
    @objc func openTapped() {
        // Creates the action sheet to show the website list.
        let websiteList = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        // Populates the action sheet with content for each object in the array "websites".
        for website in websites {
            websiteList.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        // Adds a dedicated cancel button.
        websiteList.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // This line is necessary to know where the pop over will be anchored on iPad.
        websiteList.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        // Presents a view controller modally
        present(websiteList, animated: true)
    }
    
    // Handler used in openTapped()
    func openPage(action: UIAlertAction) {						// The parameter takes the UIAlertAction selected by the user (to be used in openTapped),
        let url = URL(string: "https://" + action.title!)!		// then it uses the title property of the action and attatches to the https, after that, it's converted to be a URL.
        webView.load(URLRequest(url: url))						// Finally, the url is given to webView to load.
    }
    
    // Updates the view controller's title to be set to the web page that was most recently loaded.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    // Observes the "estimatedProgress" value from WKWebview. Needed for the progress bar setup.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)        // UIProgressView is a Float, so we need to convert estimatedProgress (which is a Double).
        }
    }
    
    // Limits which websites the browser can visit.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {               // First, we use if let to unwrap the value of url.host.
            for website in websites {           // Then, we loop through all sites in the array websites,
                if host.contains(website) {     // if the name of website is present anywhere in the host's name,
                    decisionHandler(.allow)     // we call the decisionHandler closure with a positive response.
                    return
                }
            }
        }
        decisionHandler(.cancel)                 // If the if let fails, we call closure with a negative response.
    }
   
    
    
    
}
