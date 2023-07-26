//
//  UnixTimeApp.swift
//  UnixTime
//
//  Created by Kamaal Farah on 7/26/23.
//

import SwiftUI

@main
struct UnixTimeApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    #endif

    @StateObject private var clockManager = ClockManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(clockManager)
        }
    }
}
