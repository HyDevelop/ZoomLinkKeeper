//
//  AppDelegate.swift
//  ZoomLinkKeeper
//
//  Created by Hykilpikonna on 10/22/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    let userDefaults = UserDefaults(suiteName: "group.org.hydev.zoomlink")!
    
    func application(_ app: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        // Initialize settings on fist launch
        if userDefaults.string(forKey: "calendar-url") == nil
        {
            userDefaults.setValue("calendar-url", forKey: MyConstants.defaultCalendarUrl)
            userDefaults.setValue("regex", forKey: MyConstants.defaultRegex)
        }
        if userDefaults.string(forKey: "calendar-url") == nil {
            print("what?")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: configurationForConnecting.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
