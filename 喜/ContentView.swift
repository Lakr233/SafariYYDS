//
//  ContentView.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var scanner = AppScanner()
    @State private var selectedScanType: ScanType = .electron
    @EnvironmentObject var menuBarState: MenuBarState

    var body: some View {
        contentView
            .animation(.easeInOut(duration: 0.5), value: scanner.scannedApps != nil)
            .onAppear {
                // 同步菜单栏状态
                if let storedType = UserDefaults.standard.string(forKey: "selectedScanType"),
                   let type = ScanType(rawValue: storedType)
                {
                    selectedScanType = type
                }
                menuBarState.selectedScanType = selectedScanType
                menuBarState.onScanTypeChanged = { type in
                    selectedScanType = type
                    scanner.scan(for: type)
                }
            }
            .onChange(of: selectedScanType) { newValue in
                menuBarState.selectedScanType = newValue
                UserDefaults.standard.set(newValue.rawValue, forKey: "selectedScanType")
            }
    }

    @ViewBuilder
    private var contentView: some View {
        if let scannedApps = scanner.scannedApps {
            ScanResultView(apps: scannedApps, type: selectedScanType)
                .transition(.opacity)
        } else if scanner.isScanning {
            ProgressView(String(localized: "Scanning..."))
                .frame(width: 600, height: 400, alignment: .center)
        } else {
            ProgressView()
                .frame(width: 600, height: 400, alignment: .center)
                .onAppear {
                    scanner.scan(for: selectedScanType)
                }
        }
    }
}
