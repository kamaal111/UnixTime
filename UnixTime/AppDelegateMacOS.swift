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
    private let mainMenuItemSize = CGSize(width: 150, height: 78)

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button!.image = NSImage(
            systemSymbolName: "deskclock.fill",
            accessibilityDescription: "Desk clock logo")
        statusItem.menu = menu

        NSApplication.shared.windows
            .filter({ window in window != statusItem.button!.window })
            .forEach({ window in window.close() })
    }

    private lazy var menu: NSMenu = {
        let menu = NSMenu()
        menu.addItem(mainMenuItem)
        menu.addItem(.separator())
        menu.addItem(
            withTitle: NSLocalizedString("Quit UnixTime", comment: ""),
            action: #selector(quitApp),
            keyEquivalent: "Q")
        return menu
    }()

    lazy var mainMenuItem: NSMenuItem = {
        let item = NSMenuItem()
        item.view = NSHostingView(rootView: view())
            .setFrame(NSRect(x: 0, y: 0, width: mainMenuItemSize.width, height: mainMenuItemSize.height))
        return item
    }()

    private func view() -> some View {
        MenuPopoverClock()
            .environmentObject(clockManager)
    }

    @objc
    private func quitApp(_ item: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
