//
//  UnixTimeWidgetMacOS.swift
//  UnixTimeWidgetMacOS
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import SwiftUI
import WidgetKit

@main
struct UnixTimeWidgetMacOS: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: UnixTimeProvider.widgetKind, provider: UnixTimeProvider()) { entry in
            UnixTimeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(UnixTimeProvider.configurationDisplayName)
        .description(UnixTimeProvider.configurationDescription)
        .supportedFamilies(UnixTimeProvider.supportedWidgetFamilies)
    }
}

struct UnixTimeWidgetMacOS_Previews: PreviewProvider {
    static var previews: some View {
        UnixTimeWidgetEntryView(entry: UnixTimeEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
