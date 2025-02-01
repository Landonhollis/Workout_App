//
//  Workout_AppApp.swift
//  Workout_App
//
//  Created by Landon Hollis on 1/26/25.
//

import SwiftUI

@main
struct Workout_AppApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(.blue)  // Or any color you prefer
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        // Handle universal links
        if let incomingURL = userActivity.webpageURL {
            handleIncomingURL(incomingURL)
        }
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        // Handle deep links
        handleIncomingURL(url)
        return true
    }
    
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "workoutapp",
              url.host == "share",
              url.pathComponents[1] == "workout",
              let workoutId = url.pathComponents[safe: 2] else {
            return
        }
        
        // Handle the shared workout
        // You'd typically fetch the workout details here
        print("Received shared workout with ID: \(workoutId)")
    }
}
