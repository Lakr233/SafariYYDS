//
//  ContentView.swift
//  喜
//
//  Created by QAQ on 2022/11/17.
//

import SwiftUI

struct Result: Identifiable {
    let id: UUID = .init()
    let image: NSImage
    let name: String
}

struct ContentView: View {
    
    @State var result: [Result]? = nil
    
    var body: some View {
        if result != nil {
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
            if let result {
                Spacer().frame(height: 100)
                HStack {
                    Spacer()
                    Text("您的计算机上有")
                    Text("\(result.count)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                    Text("个 Chromium 引擎！")
                    Spacer()
                }
                .font(.title)
                .bold()
                .foregroundColor(.black)
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                        ForEach(result) { item in
                            VStack {
                                Image(nsImage: item.image)
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
    
    func loadApps() {
        let searchDir = "/Applications"
        let contentes = try? FileManager.default.contentsOfDirectory(atPath: searchDir)
            .filter { $0.lowercased().hasSuffix(".app") }
        var b = [Result]()
        for item in contentes ?? [] {
            guard let bundle = Bundle(path: searchDir + "/" + item) else { continue }
            guard bundle.isElectronApp() else { continue }
            let image = NSWorkspace.shared.icon(forFile: bundle.bundlePath)
            b += [Result(image: image, name: bundle.bundleURL.lastPathComponent)]
        }
        result = b
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
