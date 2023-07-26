//
//  MenuPopoverClock.swift
//  UnixTime (macOS)
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import SwiftUI

struct MenuPopoverClock: View {
    var body: some View {
        List {
            ClockView()
            Button(action: { NSApplication.shared.terminate(self) }) {
                Text("Quit")
            }
        }
    }
}

#Preview {
    MenuPopoverClock()
}
