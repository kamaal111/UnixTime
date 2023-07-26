//
//  ContentView.swift
//  UnixTime
//
//  Created by Kamaal Farah on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ClockView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ClockManager())
    }
}
