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

    private var timer: Timer?

    init() {
        self.time = Date().timeIntervalSince1970
    }

    var formattedTime: String {
        time.int.string
    }

    func startCounting() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }

            Task { await self.setTime(to: Date().timeIntervalSince1970) }
        }
    }

    func stopCounting() {
        guard let timer else { return }

        timer.invalidate()
        self.timer = nil
    }

    @MainActor
    private func setTime(to time: TimeInterval) {
        self.time = time
    }
}
