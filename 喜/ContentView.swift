//
//  ContentView.swift
//  喜
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct Application: Identifiable {
    let id: UUID = .init()
    let icon: NSImage
    let name: String
}

struct FameView: View {
    
    @State var glories: [Application]? = nil
    
    let columns = [GridItem(.adaptive(minimum: 80))]
    
    var body: some View {
        VStack {
            if let glories {
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
    }
}

struct ContentView: View {
    
    @State var electronApps: [Application]? = nil
    @State var rosetta2Apps: [Application]? = nil
    
    var body: some View {
        if electronApps != nil {
            resultView
        } else {
            ProgressView()
                .frame(width: 600, height: 400, alignment: .center)
                .onAppear {
                    loadApps()
                }
        }
    }
    
    var resultView: some View {
        Image("喜报")
            .overlay { layout.padding() }
    }
    
    let columns = [GridItem(.adaptive(minimum: 80))]
    
    var layout: some View {
        VStack {
            Spacer().frame(height: 100)
            
            if let electronApps {
                let display = HStack {
                    Text("您的计算机上有")
                    Text("\(electronApps.count)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    Text("个 Chromium 引擎！")
                }
                .font(.title3)
                .foregroundColor(.black)
                
                if #available(macOS 13, *) {
                    display.bold()
                } else {
                    display
                }
                FameView(glories: electronApps)
            }
            
            if let rosetta2Apps {
                let display = HStack {
                    Text("您的麦金塔上有")
                    Text("\(rosetta2Apps.count)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    Text("个 Rosetta2 应用！")
                }
                .font(.title3)
                .foregroundColor(.black)
                
                if #available(macOS 13, *) {
                    display.bold()
                } else {
                    display
                }
                FameView(glories: rosetta2Apps)
            }
        }
    }
    
    func loadApps() {
        let searchDir = "/Applications"
        let contentes = try? FileManager.default.contentsOfDirectory(atPath: searchDir)
            .filter { $0.lowercased().hasSuffix(".app") }
        var b = [Application]()
        var c = [Application]()
        for item in contentes ?? [] {
            guard let bundle = Bundle(path: searchDir + "/" + item) else { continue }
            let image = NSWorkspace.shared.icon(forFile: bundle.bundlePath)
            
            if bundle.isElectronApp() {
                b += [Application(icon: image, name: bundle.bundleURL.lastPathComponent)]
                continue
            }
            
            if bundle.isRosetta2TranslatedApp() {
                c += [Application(icon: image, name: bundle.bundleURL.lastPathComponent)]
                continue
            }
        }
        electronApps = b
        rosetta2Apps = c
    }
}



extension Bundle {
    func isElectronApp() -> Bool {
        if self.executablePath?.lowercased().contains("electron") ?? false {
            return true
        }
        
        if let frameworksUrl = self.privateFrameworksURL,
           let frameworks = try? FileManager.default.contentsOfDirectory(atPath: frameworksUrl.path)
        {
            let search = frameworks.contains { $0.lowercased().contains("electron") }
            if search {
                return true
            }
        }
        return false
    }
    
    func isRosetta2TranslatedApp() -> Bool {
        guard ProcessInfo.processInfo.machineHardwareName == "arm64" else {
            return false
        }
        guard let architectures = self.executableArchitectures else {
            return false
        }
        let arm64 = NSNumber(value: NSBundleExecutableArchitectureARM64)
        return architectures.count == 1 && architectures.first != arm64
    }
}

extension ProcessInfo {
    /// Returns a `String` representing the machine hardware name or nil if there was an error invoking `uname(_:)` or decoding the response.
    ///
    /// Return value is the equivalent to running `$ uname -m` in shell.
    var machineHardwareName: String? {
        var sysinfo = utsname()
        let result = uname(&sysinfo)
        guard result == EXIT_SUCCESS else { return nil }
        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let identifier = String(bytes: data, encoding: .ascii) else { return nil }
        return identifier.trimmingCharacters(in: .controlCharacters)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
