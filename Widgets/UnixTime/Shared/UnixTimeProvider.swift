//
//  UnixTimeProvider.swift
//  UnixTime
//
//  Created by Kamaal M Farah on 27/07/2023.
//

import WidgetKit

struct UnixTimeProvider: TimelineProvider {
    typealias Entry = UnixTimeEntry

    func placeholder(in context: Context) -> UnixTimeEntry {
        UnixTimeEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (UnixTimeEntry) -> ()) {
        let entry = UnixTimeEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UnixTimeEntry>) -> ()) {
        let currentDate = Date()
        let entries = (0 ..< 4)
            .map({
                let minuteOffset = $0 * 15
                let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                return UnixTimeEntry(date: entryDate)
            })
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    static let widgetKind = "UnixTimeWidget"
    static let configurationDisplayName = NSLocalizedString("Epoch Time", comment: "")
    static let configurationDescription = NSLocalizedString("Display the current unix time.", comment: "")
    static let supportedWidgetFamilies: [WidgetFamily] = [.systemSmall]
}
