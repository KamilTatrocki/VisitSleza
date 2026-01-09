//
//  VisitSlezaApp.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 01/11/2025.
//

import SwiftUI
import UserNotifications

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    // Show notifications while app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .list, .sound]
    }
}

@main
struct VisitSlezaApp: App {
    @State private var notificationDelegate = NotificationDelegate()

    init() {
        // Install delegate early so foreground notifications can be shown
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
