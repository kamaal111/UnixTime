//
//  ClockManager.swift
//  UnixTime
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import Foundation
import KamaalExtensions

final class ClockManager: ObservableObject {
    @Published private(set) var time: TimeInterval

    init() {
        self.time = Date().timeIntervalSince1970

        startCounting()
    }

    var formattedTime: String {
        String(time.int)
    }

    private func startCounting() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.time = Date().timeIntervalSince1970
        }
    }
}
