//
//  AppDelegateMacOS.swift
//  UnixTime
//
//  Created by Kamaal M Farah on 26/07/2023.
//

#if os(macOS)
import SwiftUI
import Combine

final class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private let clockManager = ClockManager()
    private let popoverSize = CGSize(width: 150, height: 150)
    private var timeChangeSubscription = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button!.title = clockManager.formattedTime
        statusItem.button!.action = #selector(togglePopover)

        popover = NSPopover()
        popover.contentSize = NSSize(width: popoverSize.width, height: popoverSize.height)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: view())

        clockManager.$time
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }

                self.statusItem.button!.title = self.clockManager.formattedTime
            })
            .store(in: &timeChangeSubscription)
    }

    private func view() -> some View {
        ClockView()
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
#endif
