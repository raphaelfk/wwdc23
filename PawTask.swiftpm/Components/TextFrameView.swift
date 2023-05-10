//
//  TextFrameView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 15/04/23.
//

import SwiftUI

struct TextFrameView: View {
    var text: LocalizedStringKey
    var body: some View {
        Text(text)
            .font(.body)
            .foregroundColor(.black)
            .padding(25)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .background {
                Rectangle()
                    .foregroundColor(Color(red: 0.975, green: 0.884, blue: 0.77))
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding()
    }
}
