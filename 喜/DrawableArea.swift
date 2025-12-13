//
//  DrawableArea.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct DrawableArea<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, geometry.size.height * 0.25)
            }
        }
    }
}
