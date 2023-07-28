//
//  AppDelegateMacOS.swift
//  UnixTime
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import SwiftUI

final class AppDelegate: NSObject {
    private var statusItem: NSStatusItem!
    private let clockManager = ClockManager()
    private let popoverSize = CGSize(width: 180, height: 120)

    private lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: popoverSize.width, height: popoverSize.height)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: view())
        popover.delegate = self
        return popover
    }()
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        closeAllWindowsExceptForStatusBarWindow()
    }
}

extension AppDelegate: NSPopoverDelegate {
    func popoverDidClose(_ notification: Notification) {
        clockManager.stopCounting()
    }
}

extension AppDelegate {
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button!.image = NSImage(
            systemSymbolName: "deskclock.fill",
            accessibilityDescription: NSLocalizedString("Desk clock logo", comment: ""))
        statusItem.button!.action = #selector(togglePopover)
    }

    private func view() -> some View {
        MenuPopoverClock()
            .environmentObject(clockManager)
    }

    @objc
    private func togglePopover(_ button: NSStatusBarButton) {
        if popover.isShown {
            clockManager.stopCounting()
            popover.performClose(nil)
        } else {
            clockManager.startCounting()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    private func closeAllWindowsExceptForStatusBarWindow() {
        let statusItemWindow = statusItem.button!.window
        NSApplication.shared.windows
            .forEach({ window in
                guard window != statusItemWindow else { return }

                window.close()
            })
    }
}
