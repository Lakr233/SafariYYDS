# SafariYYDS

A macOS application that scans your Mac for Electron, Rosetta2, and VSCode applications.

## Features

- **Scan for Electron Apps**: Detects applications built with Electron framework
- **Scan for Rosetta2 Apps**: Identifies Intel-based apps running through Rosetta2 translation on Apple Silicon
- **Scan for VSCode Apps**: Identifies Visual Studio Code and its variants
- **Interactive Menu**: Switch between scan types via the menu button in the top-right corner or menu bar commands
- **Beautiful UI**: Animated app icon display with smooth transitions
- **Localization Support**: Multi-language interface support

## Usage

### Method 1: Via UI Menu
1. Launch the application
2. Click the menu button (three dots icon) in the top-right corner
3. Select a scan type:
   - Electron
   - Rosetta
   - VSCode
4. View the results displayed with app icons and names

### Method 2: Via Menu Bar
1. Launch the application
2. Find the "Scan Option" menu in the menu bar
3. Select the desired scan type
4. The app will automatically start scanning and display results

## Tech Stack

- **SwiftUI**: Modern user interface framework
- **AppKit**: macOS application development framework
- **Foundation**: File system and process detection

## Requirements

- macOS 13.0 or later
- Xcode 14.0 or later (for building)

## Screenshot

![](./Screenshot%202022-11-17%20at%2018.06.28.png)

## Development

The project is built with SwiftUI. Main components include:
- `Scanner.swift`: Core scanning logic
- `ContentView.swift`: Main view
- `ScanResultView.swift`: Scan results display
- `AppMenuCommands.swift`: Menu bar commands
- `FameView.swift`: App icon grid display

## License

See the [LICENSE](./LICENSE) file for details.
