//
//  ContentView.swift
//  UnixTime
//
//  Created by Kamaal Farah on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var clockManager: ClockManager

    var body: some View {
        ClockView()
            .onAppear(perform: {
                clockManager.startCounting()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ClockManager())
    }
}
