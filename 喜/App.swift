//
//  App.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct App: SwiftUI.App {
    @StateObject private var menuBarState = MenuBarState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(menuBarState)
                .ignoresSafeArea()
                .frame(minWidth: 500)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            AppMenuCommands(menuBarState: menuBarState)
        }
    }
}
