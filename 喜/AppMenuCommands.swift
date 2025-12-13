//
//  AppMenuCommands.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

class MenuBarState: ObservableObject {
    @Published var selectedScanType: ScanType = .electron
    var onScanTypeChanged: ((ScanType) -> Void)?
}

struct AppMenuCommands: Commands {
    @AppStorage("selectedScanType") private var storedScanType: String = ScanType.electron.rawValue
    let menuBarState: MenuBarState

    var body: some Commands {
        CommandMenu(String(localized: "Scan Option")) {
            ForEach(ScanType.allCases, id: \.self) { type in
                Button(action: {
                    storedScanType = type.rawValue
                    menuBarState.selectedScanType = type
                    menuBarState.onScanTypeChanged?(type)
                }) {
                    Text(type.localizedDisplayName)
                    if storedScanType == type.rawValue {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}
