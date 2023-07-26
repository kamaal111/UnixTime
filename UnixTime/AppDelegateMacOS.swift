//
//  AppDelegateMacOS.swift
//  UnixTime
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import SwiftUI
import Combine

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let clockManager = ClockManager()
    private var timeChangeSubscription = Set<AnyCancellable>()
    private let popoverSize = CGSize(width: 150, height: 150)

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        assert(statusItem.button != nil)
        assert(statusItem.isVisible)
        statusItem.button?.image = NSImage(
            systemSymbolName: "deskclock.fill",
            accessibilityDescription: "Desk clock logo")
        statusItem.button?.action = #selector(togglePopover)
    }

    private lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: popoverSize.width, height: popoverSize.height)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: view())
        return popover
    }()

    private func view() -> some View {
        MenuPopoverClock()
            .frame(width: popoverSize.width, height: popoverSize.height)
            .environmentObject(clockManager)
    }

    @objc
    private func togglePopover(_ button: NSStatusBarButton) {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
}
