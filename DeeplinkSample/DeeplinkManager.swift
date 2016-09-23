//
//  DeeplinkManager.swift
//  DeeplinkSample
//
//  Created by Akash Gupta on 9/23/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import Foundation

protocol DeepLinkDelegate {
    func handleDeepLink()
}

class DeepLinkManager {
    
    static let sharedInstance = DeepLinkManager()
    var delegate: DeepLinkDelegate? {
        didSet {
            if pendingDeepLink {
                callDeepLinkOnDelegate(delegate: delegate)
            }
        }
    }
    private var pendingDeepLink: Bool = false
    
    func handleDeepLink() {
        if let del = delegate {
            callDeepLinkOnDelegate(delegate: del)
        } else {
            pendingDeepLink = true
        }
    }
    
    private func callDeepLinkOnDelegate(delegate: DeepLinkDelegate?) {
        if let del = delegate {
            del.handleDeepLink()
            pendingDeepLink = false
        }
    }
}
