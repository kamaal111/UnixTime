//
//  MenuPopoverClock.swift
//  UnixTime (macOS)
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import SwiftUI
import KamaalUI

struct MenuPopoverClock: View {
    var body: some View {
        VStack(alignment: .leading) {
            ClockView()
        }
        .ktakeSizeEagerly(alignment: .leading)
        .padding(.horizontal, 14)
    }
}
