//
//  Scanner.swift
//  App
//
//  Created by QAQ on 2022/11/17.
//

import AppKit
import Foundation

enum ScanType: String, CaseIterable {
    case rosetta = "Rosetta"
    case electron = "Electron"
    case vscode = "VSCode"

    var localizedDisplayName: String {
        let key = switch self {
        case .rosetta:
            "ScanType.Rosetta"
        case .electron:
            "ScanType.Electron"
        case .vscode:
            "ScanType.VSCode"
        }
        return String(localized: String.LocalizationValue(key))
    }

    var displayName: String {
        "Scan Option: \(rawValue)"
    }
}

struct Application: Identifiable {
    let id: UUID = .init()
    let icon: NSImage
    let name: String
}

class AppScanner: ObservableObject {
    @Published var scannedApps: [Application]? = nil
    @Published var isScanning: Bool = false

    func scan(for type: ScanType) {
        isScanning = true
        scannedApps = nil

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }

            let searchDir = "/Applications"
            let contents = try? FileManager.default.contentsOfDirectory(atPath: searchDir)
                .filter { $0.lowercased().hasSuffix(".app") }

            var foundApps: [Application] = []

            for item in contents ?? [] {
                guard let bundle = Bundle(path: searchDir + "/" + item) else { continue }
                let image = NSWorkspace.shared.icon(forFile: bundle.bundlePath)

                var isMatch = false

                switch type {
                case .electron:
                    isMatch = bundle.isElectronApp()
                case .rosetta:
                    isMatch = bundle.isRosetta2TranslatedApp()
                case .vscode:
                    isMatch = bundle.isVSCodeApp()
                }

                if isMatch {
                    foundApps.append(Application(icon: image, name: bundle.bundleURL.lastPathComponent))
                }
            }

            // 必须 sleep 1 秒
            Thread.sleep(forTimeInterval: 1.0)

            DispatchQueue.main.async {
                self.scannedApps = foundApps
                self.isScanning = false
            }
        }
    }
}

extension Bundle {
    func isElectronApp() -> Bool {
        if executablePath?.lowercased().contains("electron") ?? false {
            return true
        }

        if let frameworksUrl = privateFrameworksURL,
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
        guard let architectures = executableArchitectures else {
            return false
        }
        let arm64 = NSNumber(value: NSBundleExecutableArchitectureARM64)
        return architectures.count == 1 && architectures.first != arm64
    }

    func isVSCodeApp() -> Bool {
        // VSCode 特定的 .icns 文件列表
        let vscodeIcons = [
            "bat.icns",
            "bower.icns",
            "c.icns",
            "config.icns",
            "cpp.icns",
            "csharp.icns",
            "css.icns",
            "default.icns",
            "go.icns",
            "html.icns",
            "jade.icns",
            "java.icns",
            "javascript.icns",
            "json.icns",
            "less.icns",
            "markdown.icns",
            "php.icns",
            "powershell.icns",
            "python.icns",
            "react.icns",
            "ruby.icns",
            "sass.icns",
            "shell.icns",
            "sql.icns",
            "typescript.icns",
            "vue.icns",
            "xml.icns",
            "yaml.icns",
        ]

        // 检查 content/resource 目录
        let contentResourcePaths = [
            bundlePath + "/Contents/Resources",
        ]

        for resourcePath in contentResourcePaths {
            guard FileManager.default.fileExists(atPath: resourcePath) else { continue }

            guard let contents = try? FileManager.default.contentsOfDirectory(atPath: resourcePath) else {
                continue
            }

            // 计算找到的 VSCode 图标文件数量
            let foundCount = contents.count(where: { fileName in
                vscodeIcons.contains { iconName in
                    fileName.lowercased() == iconName.lowercased()
                }
            })

            // 如果找到至少 5 个，就认为是 VSCode
            if foundCount >= 5 {
                return true
            }
        }

        return false
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
