//
//  FameView.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct FameView: View {
    let glories: [Application]

    @State private var appearedIndices: Set<Int> = []
    private let itemWidth: CGFloat = 100
    private let spacing: CGFloat = 20

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content(availableWidth: geometry.size.width)
                    .frame(maxWidth: .infinity)
            }
        }
        .onChange(of: glories.count) { _ in
            appearedIndices.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for index in glories.indices {
                    _ = withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.05)) {
                        appearedIndices.insert(index)
                    }
                }
            }
        }
        .onAppear {
            if appearedIndices.isEmpty {
                for index in glories.indices {
                    _ = withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.05)) {
                        appearedIndices.insert(index)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func content(availableWidth: CGFloat) -> some View {
        let columnsCount = calculateColumns(availableWidth: availableWidth)

        // 如果应用数量少于一行能容纳的数量，使用 HStack 居中显示
        if glories.count <= columnsCount {
            HStack(spacing: spacing) {
                ForEach(glories.indices, id: \.self) { index in
                    AppIconCard(
                        application: glories[index],
                        index: index,
                        isVisible: appearedIndices.contains(index),
                    ) {
                        appearedIndices.insert(index)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        } else {
            // 如果应用数量较多，使用网格布局
            let columns = Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing), count: columnsCount)

            LazyVGrid(columns: columns, alignment: .center, spacing: spacing) {
                ForEach(glories.indices, id: \.self) { index in
                    AppIconCard(
                        application: glories[index],
                        index: index,
                        isVisible: appearedIndices.contains(index),
                    ) {
                        appearedIndices.insert(index)
                    }
                }
            }
        }
    }

    private func calculateColumns(availableWidth: CGFloat) -> Int {
        // 计算能容纳多少列，确保不会裁剪
        // 公式: availableWidth >= columnsCount * itemWidth + (columnsCount - 1) * spacing
        // 即: availableWidth >= columnsCount * (itemWidth + spacing) - spacing
        // 所以: columnsCount <= (availableWidth + spacing) / (itemWidth + spacing)
        let columnsCount = Int((availableWidth + spacing) / (itemWidth + spacing)) - 1
        return max(1, columnsCount) // 至少1列
    }
}
