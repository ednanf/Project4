# Project4 (with scrolling working properly)
HackingWithSwift Project 4: Easy Browser

The original instructions aren't working properly with the newest Xcode/iOS.

To fix the issue, simply add the line below viewDidLoad():

webView.scrollView.contentInsetAdjustmentBehavior = .automatic

Now, the scrolling works as intended.
