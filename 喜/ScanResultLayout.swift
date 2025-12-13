//
//  ScanResultLayout.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct ScanResultLayout: View {
    let apps: [Application]
    let type: ScanType
    @State private var isTextVisible = false

    var body: some View {
        VStack(spacing: 20) {
            // 统计信息
            HStack(spacing: 8) {
                Text(String(localized: "Your Mac has"))
                Text("\(apps.count)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.orange, Color.red, Color.orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing,
                        ),
                    )
                Text(getCountText(for: type))
            }
            .font(.title3)
            .bold()
            .foregroundColor(.black)
            .shadow(color: .white, radius: 4, x: 0, y: 0)
            .shadow(color: .white, radius: 4, x: 0, y: 0)
            .opacity(isTextVisible ? 1 : 0)
            .scaleEffect(isTextVisible ? 1 : 0.8)

            // 应用网格
            FameView(glories: apps)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                isTextVisible = true
            }
        }
    }

    private func getCountText(for type: ScanType) -> String {
        switch type {
        case .electron:
            String(localized: "Chromium engines!")
        case .rosetta:
            String(localized: "Rosetta2 apps!")
        case .vscode:
            String(localized: "Visual Studio Code!")
        }
    }
}
