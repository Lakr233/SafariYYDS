//
//  ScanTypeMenu.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct ScanTypeMenu: View {
    @Binding var selectedScanType: ScanType
    let onTypeSelected: (ScanType) -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Menu {
                    Text(String(localized: "Scan Option"))
                        .font(.headline)
                    Divider()
                    ForEach(ScanType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedScanType = type
                            onTypeSelected(type)
                        }) {
                            Text(type.localizedDisplayName)
                            if selectedScanType == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(8)
                }
                .menuStyle(.borderlessButton)
                .padding(.trailing, 16)
                .padding(.top, 16)
            }
            Spacer()
        }
    }
}
