# Architecture

## Overview

Safo has two targets: a macOS SwiftUI app (`Safo`) and a CLI tool (`safo`). The CLI launches
the app or communicates with a running instance. The app renders markdown files using MarkdownUI
with a custom theme and watches the file system for changes.

## Dependencies

| Package | Purpose | Version |
|---------|---------|---------|
| [MarkdownUI](https://github.com/gonzalezreal/swift-markdown-ui) | GFM markdown rendering in SwiftUI | 2.4+ |
| [Splash](https://github.com/JohnSundell/Splash) | Swift-native syntax highlighting | 0.16+ |

No other dependencies. Keep it minimal.

## Targets

### Safo (macOS App)
- SwiftUI app using `@main` App protocol
- macOS 14+ (Sonoma)
- Renders markdown, manages window, watches files

### safo (CLI Tool)
- Swift executable
- Launches the app via `open` or sends file path to running instance via URL scheme
- Resolves relative paths to absolute before sending

## URL Scheme

`safo://open?path=/absolute/path/to/file.md`

The CLI tool constructs this URL and opens it. The app handles it via `onOpenURL`.

## Data Flow

```
Terminal                    CLI (safo)                  App (Safo)
───────                    ──────────                  ──────────
safo file.md  ──────────>  Resolve path  ──────────>  onOpenURL / launch args
                           Build URL                        │
                           open URL                         ▼
                                                    DocumentViewModel
                                                    ├── loads file content
                                                    ├── starts FileWatcher
                                                    └── scans directory
                                                            │
                                                            ▼
                                                    ContentView
                                                    ├── MarkdownContentView (rendered MD)
                                                    ├── SidebarView (file list)
                                                    └── ToolbarView (controls)
```

## Models

### MarkdownDocument
```swift
struct MarkdownDocument: Identifiable, Equatable {
    let id: URL           // file URL (unique identifier)
    let url: URL          // absolute file URL
    var content: String   // raw markdown content
    var lastModified: Date

    var fileName: String  // derived: url.lastPathComponent
    var relativePath: String // derived: relative to root directory
}
```

### DirectoryListing
```swift
struct DirectoryListing {
    let rootURL: URL                    // base directory
    var files: [URL]                    // all .md files, sorted alphabetically
    var currentIndex: Int               // index of current file in list

    var currentFile: URL?               // files[currentIndex]
    var hasPrevious: Bool               // currentIndex > 0
    var hasNext: Bool                   // currentIndex < files.count - 1

    mutating func goToNext()
    mutating func goToPrevious()
    mutating func goTo(url: URL)
}
```

## ViewModels

### DocumentViewModel (ObservableObject)
```swift
@MainActor
class DocumentViewModel: ObservableObject {
    @Published var document: MarkdownDocument?
    @Published var directoryListing: DirectoryListing?
    @Published var sidebarVisible: Bool = false
    @Published var error: SafoError?

    private var fileWatcher: FileWatcher?

    func open(url: URL)                 // load file, scan directory, start watching
    func navigateToNext()               // next .md in directory
    func navigateToPrevious()           // previous .md in directory
    func navigateTo(url: URL)           // specific file in directory
    func copyToClipboard()              // copy raw markdown to system clipboard
    func toggleSidebar()                // show/hide sidebar
}
```

### FileWatcher
```swift
class FileWatcher {
    // Uses DispatchSource.makeFileSystemObjectSource to watch file changes
    // Calls onChange callback when file is modified
    // Automatically stops when deallocated

    init(url: URL, onChange: @escaping () -> Void)
    func start()
    func stop()
}
```

## App Lifecycle

### Launch with file argument
1. `SafoApp.init` checks for launch arguments or URL scheme
2. Creates `DocumentViewModel`
3. Calls `viewModel.open(url:)` with the file path
4. `WindowGroup` renders `ContentView`
5. `AppDelegate` positions window (right side, 40% width, full height)

### Receive file while running
1. `onOpenURL` receives `safo://open?path=...`
2. Extracts path, calls `viewModel.open(url:)`
3. Same window navigates to new file

### File changes on disk
1. `FileWatcher` detects modification
2. Reloads file content
3. `document.content` updates
4. SwiftUI re-renders the markdown view

## Error States

| Error | Behavior |
|-------|----------|
| File not found | Show message in content area: "File not found: {path}" |
| Not a .md file | Show message: "Safo only opens markdown files" |
| Permission denied | Show message: "Cannot read file: permission denied" |
| Empty file | Show message: "Empty file" (subtle, not error-styled) |
| File deleted while viewing | Show message: "File was deleted", stop watcher |

## File Structure

```
safo/
├── Package.swift                      # SPM manifest
├── Sources/
│   ├── Safo/                          # macOS app target
│   │   ├── SafoApp.swift              # @main, WindowGroup, onOpenURL
│   │   ├── AppDelegate.swift          # Window positioning, lifecycle
│   │   ├── Models/
│   │   │   ├── MarkdownDocument.swift
│   │   │   └── DirectoryListing.swift
│   │   ├── ViewModels/
│   │   │   └── DocumentViewModel.swift
│   │   ├── Views/
│   │   │   ├── ContentView.swift      # Main layout (sidebar + content)
│   │   │   ├── MarkdownContentView.swift  # Scrollable rendered markdown
│   │   │   ├── SidebarView.swift      # File list
│   │   │   └── ToolbarItems.swift     # Toolbar buttons
│   │   ├── Theme/
│   │   │   ├── SafoTheme.swift        # MarkdownUI theme
│   │   │   ├── CodeTheme.swift        # Splash code block theme
│   │   │   └── Tokens.swift           # Design token constants
│   │   └── Utilities/
│   │       ├── FileWatcher.swift      # DispatchSource file monitoring
│   │       └── SafoError.swift        # Error types
│   └── safo-cli/                      # CLI tool target
│       └── SafoCLI.swift              # main entry, path resolution, URL open
├── Resources/
│   └── Info.plist                     # URL scheme, file type associations
├── docs/
│   └── ...
└── PRODUCT-BRIEF.md
```
