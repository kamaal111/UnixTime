//
//  AppLogoCreatorScreen.swift
//  Playground
//
//  Created by Kamaal M Farah on 27/07/2023.
//

import SwiftUI
import KamaalUI
import KamaalUtils

let PLAYGROUND_SELECTABLE_COLORS: [Color] = [
    .black,
    .accentColor
]

struct AppLogoCreatorScreen: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        KScrollableForm {
            KJustStack {
                logoSection
                customizationSection
            }
            .padding(.all, 16)
            .ktakeSizeEagerly(alignment: .topLeading)
        }
    }

    private var logoSection: some View {
        KSection(header: "Logo") {
            HStack(alignment: .top) {
                viewModel.logoView(
                    size: viewModel.previewLogoSize,
                    cornerRadius: viewModel.hasCurves ? viewModel.curvedCornersSize : 0
                )
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        KFloatingTextField(
                            text: $viewModel.exportLogoSize,
                            title: "Export logo size",
                            textFieldType: .numbers
                        )
                        HStack {
                            Button(action: { viewModel.setRecommendedLogoSize() }) {
                                Text("Logo size")
                                    .foregroundColor(.accentColor)
                            }
                            .disabled(viewModel.disableLogoSizeButton)
                            Button(action: { viewModel.setRecommendedAppIconSize() }) {
                                Text("Icon size")
                                    .foregroundColor(.accentColor)
                            }
                            .disabled(viewModel.disableAppIconSizeButton)
                        }
                        .padding(.bottom, -8)
                    }
                    HStack {
                        Button(action: viewModel.exportLogo) {
                            Text("Export logo")
                                .foregroundColor(.accentColor)
                        }
                        Button(action: viewModel.exportLogoAsIconSet) {
                            Text("Export logo as IconSet")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
    }

    private var customizationSection: some View {
        KSection(header: "Customization") {
            AppLogoColorFormRow(title: "Has a background") {
                Toggle(viewModel.hasABackground ? "Yup" : "Nope", isOn: $viewModel.hasABackground)
            }
            .padding(.bottom, 16)
            .padding(.top, 8)
            AppLogoColorSelector(color: $viewModel.backgroundColor, title: "Background color")
                .disabled(viewModel.disabledBackgroundColorButtons)
                .padding(.bottom, 16)
            AppLogoColorSelector(color: $viewModel.primaryColor, title: "Primary color")
                .padding(.bottom, 16)
            AppLogoColorFormRow(title: "Has curves") {
                Toggle(viewModel.hasCurves ? "Yup" : "Nope", isOn: $viewModel.hasCurves)
            }
            .padding(.bottom, 16)
            .disabled(viewModel.disableHasCurveToggle)
            AppLogoColorFormRow(title: "Curve size") {
                Stepper("\(Int(viewModel.curvedCornersSize))", value: $viewModel.curvedCornersSize)
            }
            .disabled(viewModel.disableCurvesSize)
        }
    }
}

private final class ViewModel: ObservableObject {
    @Published var curvedCornersSize: CGFloat = 16
    @Published var hasABackground = true
    @Published var hasCurves = true
    @Published var backgroundColor = PLAYGROUND_SELECTABLE_COLORS[0]
    @Published var primaryColor = PLAYGROUND_SELECTABLE_COLORS[1]
    @Published var exportLogoSize = "400" {
        didSet {
            let filteredExportLogoSize = exportLogoSize.filter(\.isNumber)
            if exportLogoSize != filteredExportLogoSize {
                exportLogoSize = filteredExportLogoSize
            }
        }
    }

    let previewLogoSize: CGFloat = 150
    private let fileManager = FileManager.default

    enum Errors: Error {
        case conversionFailure
    }

    var disabledBackgroundColorButtons: Bool {
        !hasABackground
    }

    var disableLogoSizeButton: Bool {
        exportLogoSize == "400"
    }

    var disableAppIconSizeButton: Bool {
        exportLogoSize == "800"
    }

    var disableHasCurveToggle: Bool {
        !hasABackground
    }

    var disableCurvesSize: Bool {
        !hasCurves || disableHasCurveToggle
    }

    @MainActor
    func setRecommendedLogoSize() {
        withAnimation { exportLogoSize = "400" }
    }

    @MainActor
    func setRecommendedAppIconSize() {
        withAnimation { exportLogoSize = "800" }
    }

    func logoView(size: CGFloat, cornerRadius: CGFloat) -> some View {
        AppLogo(
            size: size,
            backgroundColor: hasABackground ? backgroundColor : .white.opacity(0),
            primaryColor: primaryColor,
            curvedCornersSize: cornerRadius)
    }

    func exportLogo() {
        Task {
            let logoViewData = try! await getLogoViewImageData()
            let logoName = "logo.png"
            let panel = try! await SavePanel.save(filename: logoName).get()
            let saveURL = await panel.url!
            if fileManager.fileExists(atPath: saveURL.path) {
                try? fileManager.removeItem(at: saveURL)
            }

            try! logoViewData.write(to: saveURL)
        }
    }

    func exportLogoAsIconSet() {
        Task {
            let temporaryDirectory = fileManager.temporaryDirectory
            let logoViewData = try! await getLogoViewImageData()

            let appIconScriptResult = try! Shell
                .runAppIconGenerator(input: logoViewData, output: temporaryDirectory)
                .get()
            assert(appIconScriptResult.splitLines.last!.hasPrefix("done creating icons"))

            let iconSetName = "AppIcon.appiconset"
            let iconSetURL = try! fileManager
                .findDirectoryOrFile(inDirectory: temporaryDirectory, searchPath: iconSetName)!
            defer { try? fileManager.removeItem(at: iconSetURL) }

            let panel = try! await SavePanel.save(filename: iconSetName).get()
            let saveURL = await panel.url!
            if fileManager.fileExists(atPath: saveURL.path) {
                try? fileManager.removeItem(at: saveURL)
            }

            try! fileManager.moveItem(at: iconSetURL, to: saveURL)
        }
    }

    @MainActor
    private func getLogoViewImageData() async throws -> Data {
        let data = ImageRenderer(content: logoToExport)
            .nsImage?
            .tiffRepresentation
        guard let data else { throw Errors.conversionFailure }

        let pngRepresentation = NSBitmapImageRep(data: data)?
            .representation(using: .png, properties: [:])
        guard let pngRepresentation else { throw Errors.conversionFailure }

        return pngRepresentation
    }

    private var logoToExport: some View {
        let size = Double(exportLogoSize)!.cgFloat
        return logoView(size: size, cornerRadius: hasCurves ? curvedCornersSize * (size / previewLogoSize) : 0)
    }
}

#Preview {
    AppLogoCreatorScreen()
}
