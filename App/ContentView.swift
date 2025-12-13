//
//  ContentView.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct FameView: View {
    let glories: [Application]

    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(glories) { item in
                    VStack {
                        Image(nsImage: item.icon)
                            .antialiased(true)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Text(item.name)
                            .font(.subheadline)
                            .minimumScaleFactor(0.5)
                    }
                    .padding()
                    .frame(width: 80, height: 80)
                    .background(Color.white.opacity(0.5).cornerRadius(8))
                    .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ContentView: View {
    @StateObject private var scanner = AppScanner()
    @State private var selectedScanType: ScanType = .electron

    var body: some View {
        ZStack {
            if let scannedApps = scanner.scannedApps {
                resultView(apps: scannedApps, type: selectedScanType)
            } else if scanner.isScanning {
                ProgressView("Scanning...")
                    .frame(width: 600, height: 400, alignment: .center)
            } else {
                ProgressView()
                    .frame(width: 600, height: 400, alignment: .center)
                    .onAppear {
                        scanner.scan(for: selectedScanType)
                    }
            }

            // Menu button in top-right corner
            VStack {
                HStack {
                    Spacer()
                    Menu {
                        ForEach(ScanType.allCases, id: \.self) { type in
                            Button(action: {
                                selectedScanType = type
                                scanner.scan(for: type)
                            }) {
                                Text(type.displayName)
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

    func resultView(apps: [Application], type: ScanType) -> some View {
        Image("Celebration")
            .overlay {
                layout(apps: apps, type: type)
                    .padding()
            }
    }

    func layout(apps: [Application], type: ScanType) -> some View {
        VStack {
            Spacer().frame(height: 100)

            let display = HStack {
                Text("Your Mac has")
                Text("\(apps.count)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                Text(getCountText(for: type))
            }
            .font(.title3)
            .foregroundColor(.black)

            if #available(macOS 13, *) {
                display.bold()
            } else {
                display
            }

            FameView(glories: apps)
        }
    }

    func getCountText(for type: ScanType) -> String {
        switch type {
        case .electron:
            "Chromium engines!"
        case .rosetta:
            "Rosetta2 apps!"
        case .vscode:
            "Visual Studio Code!"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
