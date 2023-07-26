//
//  AppDelegateMacOS.swift
//  UnixTime
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import Cocoa
import Combine

final class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private let clockManager = ClockManager()
    private let popoverSize = CGSize(width: 150, height: 150)
    private var timeChangeSubscription = Set<AnyCancellable>()

    lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        assert(statusItem.button != nil)
        statusItem.button?.title = clockManager.formattedTime
        return statusItem
    }()

    lazy var menu: NSMenu = {
        let menu = NSMenu()
        menu.addItem(withTitle: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        return menu
    }()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem.menu = menu
        setSubscriptions()
    }

    private func setSubscriptions() {
        clockManager.$time
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }

                assert(self.statusItem.button != nil)
                self.statusItem.button?.title = self.clockManager.formattedTime
            })
            .store(in: &timeChangeSubscription)
    }

    @objc
    private func quitApp() {
        NSApplication.shared.terminate(self)
    }
}
