//
//  AppDelegate.swift
//  DeeplinkSample
//
//  Created by Akash Gupta on 9/21/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIROptions.default().deepLinkURLScheme = "twdeeplink"
        FIRApp.configure()
        
        Fabric.with([Crashlytics.self, Branch.self])
        
        Branch.getInstance().initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { params, error in
            guard error == nil else { return }
            guard let userDidClick = params["+clicked_branch_link"] as? Bool else { return }
            if userDidClick {
                // This code will execute when your app is opened from a Branch deep link, which
                // means that you can route to a custom activity depending on what they clicked.
                // In this example, we'll just print out the data from the link that was clicked.
                print("deep link data: ", params)
                // Load a reference to the storyboard and grab a reference to the navigation controller
                DeepLinkManager.sharedInstance.handleDeepLink()
            }
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
            
        Branch.getInstance().handleDeepLink(url)
        
        return application(app, open: url, sourceApplication: nil, annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let dynamicLink = FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url)
        if let dynamicLink = dynamicLink {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            DeepLinkManager.sharedInstance.handleDeepLink()
            return true
        }
        
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        let handled = FIRDynamicLinks.dynamicLinks()?.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            // ...
            DeepLinkManager.sharedInstance.handleDeepLink()
        }
        
        let handledBranch = Branch.getInstance().continue(userActivity)
        
        return handled! || handledBranch
    }


}

