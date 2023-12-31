//
//  ClockView.swift
//  UnixTime
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import SwiftUI

struct ClockView: View {
    @EnvironmentObject private var clockManager: ClockManager

    var body: some View {
        VStack(alignment: .leading) {
            Text("Epoch timestamp")
                .font(.headline)
            Text(clockManager.formattedTime)
                .padding(.vertical, 8)
        }
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView()
            .environmentObject(ClockManager())
    }
}
