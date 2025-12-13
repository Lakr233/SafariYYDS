//
//  AppIconCard.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct AppIconCard: View {
    let application: Application
    let index: Int
    let isVisible: Bool
    let onAppear: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Image(nsImage: application.icon)
                .antialiased(true)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text(application.name)
                .font(.body)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .shadow(color: .white, radius: 2, x: 0, y: 0)
                .shadow(color: .white, radius: 2, x: 0, y: 0)
        }
        .padding(12)
        .frame(width: 100, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.85))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2),
        )
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.3)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.05)) {
                onAppear()
            }
        }
    }
}
