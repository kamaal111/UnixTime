//
//  AppLogo.swift
//  Playground
//
//  Created by Kamaal M Farah on 27/07/2023.
//

import SwiftUI
import KamaalUI
import KamaalExtensions

struct AppLogo: View {
    let size: CGFloat
    let backgroundColor: Color
    let primaryColor: Color
    let curvedCornersSize: CGFloat

    var body: some View {
        ZStack {
            gradientBackgroundColor
            VStack {
                Text("1970")
                    .font(.custom("VCROSDMono", size: size / 8))
                    .bold()
                    .padding(.bottom, -4)
                ZStack {
                    Image(systemName: "memorychip.fill")
                        .kSize(.squared(size / 2))
                        .rotationEffect(.degrees(90))
                }
            }
            .foregroundColor(primaryColor)
            .padding(.top, -(size / 16))
        }
        .frame(width: size, height: size)
        .cornerRadius(curvedCornersSize)
    }

    private var gradientBackgroundColor: some View {
        LinearGradient(colors: [backgroundColor, backgroundColor, primaryColor], startPoint: .top, endPoint: .bottom)
    }
}

#Preview {
    AppLogo(size: 150, backgroundColor: .black, primaryColor: .accentColor, curvedCornersSize: 16)
        .padding(.all)
        .previewLayout(.sizeThatFits)
}
