//
//  ScanResultView.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct ScanResultView: View {
    let apps: [Application]
    let type: ScanType

    var body: some View {
        ZStack {
            // 背景图片
            Image("Celebration")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            // 可绘制区域
            DrawableArea {
                ScanResultLayout(apps: apps, type: type)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
    }
}
