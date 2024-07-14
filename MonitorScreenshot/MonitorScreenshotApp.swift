//
//  MonitorScreenshot.swift
//  MonitorScreenshot
//
//  Created by Payal Kandlur on 31/03/24.
//

import SwiftUI
import UIKit

@main
struct MonitorScreenshot_POCApp: App {
    @StateObject var monitorScreenshot = MonitorScreenshot()
    let center = UNUserNotificationCenter.current()
        
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            // Request authorization for notifications
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notification authorization granted")
                } else {
                    print("Notification authorization denied")
                }
            }
            return true
    }
}

