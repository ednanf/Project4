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
        webView.navigationDelegate = self   // Then we assigned the navigationDelegate property to self (the current view controller).
        view = webView                      // Finally, we made the root view of the view controller to be webView.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Fix for the overlapping content with clock/battery/signal!!
		webView.scrollView.contentInsetAdjustmentBehavior = .automatic
		
                                                                    // ATTENTION: we need to turn a string into a URL type to put in URLRequest!!!
        let url = URL(string: "https://www.hackingwithswift.com")!  // First, we create a new data type called URL,
        webView.load(URLRequest(url: url))                          // then we create a new URLRequest object from that URL and give it to web view to load.
        webView.allowsBackForwardNavigationGestures = true          // This line allows the gesture of swiping to move backwards and forward.
        
        // Navigation bar button to open the website list.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
		
	}
	
    
// MARK: - Functions
    
    @objc func openTapped() {
        // Creates the action sheet to show the website list.
        let websiteList = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        // Populates the action sheet with content.
        websiteList.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        websiteList.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        websiteList.addAction(UIAlertAction(title: "google.com", style: .default, handler: openPage))
        websiteList.addAction(UIAlertAction(title: "Cancel", style: .cancel)) // Adds a dedicated cancel button.
        
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
	
	
	
	
}
