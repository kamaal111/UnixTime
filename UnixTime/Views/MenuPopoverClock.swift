//
//  MenuPopoverClock.swift
//  UnixTime (macOS)
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import SwiftUI
import KamaalUI

private let quitKeyboardShortcut = KeyboardShortcutConfiguration(key: KeyEquivalent("Q"), modifiers: .command)
private let keyboardShortcuts = [
    quitKeyboardShortcut
]

struct MenuPopoverClock: View {
    var body: some View {
        KeyboardShortcutView(
            shortcuts: keyboardShortcuts,
            onEmit: { configuration in onKeyboardShortcutTrigger(configuration) }) {
                VStack(alignment: .leading) {
                    ClockView()
                    Spacer()
                    Divider()
                    Button(action: { onQuit() }) {
                        HStack {
                            Text("Quit UnixTime")
                            Spacer()
                            Text("􀆔Q")
                                .bold()
                        }
                        .kInvisibleFill()
                        .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    .ktakeWidthEagerly(alignment: .trailing)
                    .padding(.top, 4)
                }
                .ktakeSizeEagerly(alignment: .topLeading)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            }
    }

    private func onKeyboardShortcutTrigger(_ configuration: KeyboardShortcutConfiguration) {
        switch configuration {
        case quitKeyboardShortcut: onQuit()
        default: assertionFailure("Unconfigured shortcut triggered")
        }
    }

    private func onQuit() {
        NSApplication.shared.terminate(self)
    }
}
