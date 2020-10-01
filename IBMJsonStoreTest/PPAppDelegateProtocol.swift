//
//  PPAppDelegateProtocol.swift
//  mobileapp
//
//  Created by tyl on 11/10/19.
//  Copyright © 2019 sppl. All rights reserved.
//
//
import UIKit

@objc public protocol PPAppDelegteProtocol {
    @objc optional func application(_ application: UIApplication,
                                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool

    @objc optional func applicationDidEnterBackground(_ application: UIApplication)

    @objc optional func applicationDidBecomeActive(_ application: UIApplication)

    @objc optional func applicationWillTerminate(_ application: UIApplication)

    @objc optional func application(_ app: UIApplication,
                                    open url: URL,
                                    options: [UIApplication.OpenURLOptionsKey: Any])
        -> Bool

    @objc optional func application(_ application: UIApplication,
                                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    
    @objc optional  func application(_ application: UIApplication,
                                     continue userActivity: NSUserActivity,
                                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool

    @objc optional func application(_ application: UIApplication,
                                    didFailToRegisterForRemoteNotificationsWithError error: Error)
}
extension PPAppDelegteProtocol {
    public var name: String {
        return String(describing: type(of: self)) 
    }
}
