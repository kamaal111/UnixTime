//
//  UnixTimeWidgetIOS.swift
//  UnixTimeWidgetIOS
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entries = (0 ..< 4)
            .map({
                let minuteOffset = $0 * 15
                let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                return SimpleEntry(date: entryDate)
            })
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct UnixTimeWidgetIOSEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Epoch timestamp")
                .font(.headline)
            Text(String(Int(Date().timeIntervalSince1970)))
                .padding(.top, 2)
            Spacer()
            Text("Last updated: \(formattedLastUpdatedDate)")
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
    }

    private var formattedLastUpdatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: entry.date)
    }
}

struct UnixTimeWidgetIOS: Widget {
    let kind: String = "UnixTimeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            UnixTimeWidgetIOSEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct UnixTimeWidgetIOS_Previews: PreviewProvider {
    static var previews: some View {
        UnixTimeWidgetIOSEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
