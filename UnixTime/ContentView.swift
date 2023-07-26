//
//  ContentView.swift
//  UnixTime
//
//  Created by Kamaal Farah on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var clockManager = ClockManager()

    var body: some View {
        VStack {
            Text(clockManager.formattedTime)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
