//
//  AppDelegate.swift
//  RoomBooking
//
//  Created by Daira Bezzato on 24/09/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import UIKit
import GTMAppAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if  (currentAuthorizationFlow?.resumeExternalUserAgentFlow(with: url))! {
            self.currentAuthorizationFlow = nil
            return true
        }
        return false
    }
    
}
