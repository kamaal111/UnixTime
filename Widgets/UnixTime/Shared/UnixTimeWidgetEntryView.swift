//
//  UnixTimeWidgetEntryView.swift
//  UnixTime
//
//  Created by Kamaal M Farah on 27/07/2023.
//

import SwiftUI
import WidgetKit
import KamaalExtensions

struct UnixTimeWidgetEntryView: View {
    var entry: UnixTimeProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Epoch timestamp")
                .font(.headline)
            Text(entry.date.timeIntervalSince1970.int.string)
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

struct UnixTimeWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        UnixTimeWidgetEntryView(entry: UnixTimeEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
