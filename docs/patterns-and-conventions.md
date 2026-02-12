# Patterns & Conventions

Solutions to problems you will encounter building Safo. Read before implementing.

---

## 0. MarkdownUI Custom Theme

**Problem:** MarkdownUI ships with default themes but Safo needs fully custom typography,
colors, and spacing for every markdown element.

**Solution:** Create a custom `Theme` conforming to MarkdownUI's `Theme` protocol. Override
every block and inline style.

```swift
import MarkdownUI

struct SafoTheme: Theme {
    // Use MarkdownUI's theme API to customize:
    // - text styles (body, code, headings)
    // - block styles (paragraph, blockquote, code block, table, list)
    // - inline styles (strong, emphasis, strikethrough, code, link)
    //
    // Reference: https://github.com/gonzalezreal/swift-markdown-ui
    // Look at Theme+DocC.swift and Theme+GitHub.swift in the repo for examples.
}
```

**Gotcha:** MarkdownUI 2.x uses a declarative theme system with `BlockStyle` and
`InlineStyle`. Do not try to use AttributedString directly. Work with the theme API.

**Gotcha:** For heading sizes, MarkdownUI gives you the heading level (1-6) in the
`BlockConfiguration`. Use a switch to apply different sizes per level.

---

## 1. Splash Integration with MarkdownUI

**Problem:** MarkdownUI needs a code syntax highlighter. Splash is Swift-native but needs
to be wired into MarkdownUI's code block rendering.

**Solution:** MarkdownUI 2.x supports custom code syntax highlighters via the
`.markdownCodeSyntaxHighlighter` modifier. Create a Splash-based highlighter.

```swift
import MarkdownUI
import Splash

struct SplashCodeHighlighter: CodeSyntaxHighlighter {
    let theme: Splash.Theme

    func highlightCode(_ code: String, language: String?) -> Text {
        guard let language = language else {
            return Text(code)
        }
        // Use Splash's SyntaxHighlighter to produce highlighted output
        // Convert Splash's attributed output to SwiftUI Text
    }
}
```

**Gotcha:** Splash only highlights Swift natively. For other languages, it provides basic
keyword highlighting. This is acceptable for v1. For more languages, consider switching to
a different highlighter later.

**Gotcha:** If Splash doesn't recognize the language, fall back to plain monospace text.
Never crash on unknown languages.

---

## 2. Window Positioning on Launch

**Problem:** Safo needs to open at 40% screen width, full height, positioned on the right
side of the screen.

**Solution:** Use `NSApplicationDelegate` to position the window after it appears.

```swift
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        positionWindow()
    }

    private func positionWindow() {
        guard let screen = NSScreen.main else { return }
        guard let window = NSApplication.shared.windows.first else { return }

        let screenFrame = screen.visibleFrame
        let width = screenFrame.width * Tokens.Layout.windowWidthRatio
        let frame = NSRect(
            x: screenFrame.maxX - width,
            y: screenFrame.minY,
            width: width,
            height: screenFrame.height
        )
        window.setFrame(frame, display: true, animate: false)
    }
}
```

**Gotcha:** Use `screen.visibleFrame` not `screen.frame`. The visible frame excludes the
menu bar and dock.

**Gotcha:** The window may not exist yet when `applicationDidFinishLaunching` fires. Use
`DispatchQueue.main.async` if needed, or observe `NSWindow.didBecomeKeyNotification`.

---

## 3. File Watching with DispatchSource

**Problem:** Safo must detect when the currently viewed file changes on disk and reload.

**Solution:** Use `DispatchSource.makeFileSystemObjectSource` to watch a specific file.

```swift
class FileWatcher {
    private var source: DispatchSourceFileSystemObject?
    private var fileDescriptor: Int32 = -1

    init(url: URL, onChange: @escaping () -> Void) {
        fileDescriptor = open(url.path, O_EVTONLY)
        guard fileDescriptor >= 0 else { return }

        source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: [.write, .rename, .delete],
            queue: .main
        )

        source?.setEventHandler { [weak self] in
            onChange()
        }

        source?.setCancelHandler { [weak self] in
            guard let fd = self?.fileDescriptor, fd >= 0 else { return }
            close(fd)
        }

        source?.resume()
    }

    deinit {
        source?.cancel()
    }
}
```

**Gotcha:** Always close the file descriptor in the cancel handler, not in deinit directly.
The cancel handler runs asynchronously.

**Gotcha:** Some editors (like vim) write by creating a new file and renaming. This triggers
`.rename` or `.delete` on the original descriptor. When you detect rename/delete, re-create
the watcher for the same path.

**Gotcha:** Debounce the onChange callback (100ms). Editors may write multiple times rapidly.

---

## 4. URL Scheme Handling

**Problem:** The CLI needs to tell a running Safo instance to open a specific file.

**Solution:** Register a custom URL scheme in Info.plist and handle it in SwiftUI.

Info.plist:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>safo</string>
        </array>
        <key>CFBundleURLName</key>
        <string>com.significa.safo</string>
    </dict>
</array>
```

SwiftUI handler:
```swift
@main
struct SafoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // url = safo://open?path=/absolute/path/to/file.md
                    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                          let path = components.queryItems?.first(where: { $0.name == "path" })?.value
                    else { return }
                    viewModel.open(url: URL(fileURLWithPath: path))
                }
        }
    }
}
```

**Gotcha:** The path in the URL must be percent-encoded. The CLI must encode it.

**Gotcha:** `onOpenURL` fires both when the app launches from a URL and when an already
running app receives a URL. Handle both cases identically.

---

## 5. Single Instance Behavior

**Problem:** Running `safo file.md` when Safo is already open should navigate to the new
file in the existing window, not open a second window.

**Solution:** Use `handlesExternalEvents` on the WindowGroup and configure the app to
reuse the existing window.

```swift
@main
struct SafoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
    }
}
```

**Gotcha:** By default, `WindowGroup` creates a new window for each external event. The
`handlesExternalEvents(matching:)` modifier with `"*"` routes all events to the existing
window.

**Gotcha:** Also set `NSSupportsAutomaticTermination` and `NSSupportsSuddenTermination` to
`false` in Info.plist if you want predictable lifecycle behavior.

---

## 6. CLI Tool Implementation

**Problem:** `safo file.md` must launch the app or send the file to a running instance.

**Solution:** The CLI resolves the path to absolute, constructs a URL scheme, and opens it.

```swift
import Foundation

@main
struct SafoCLI {
    static func main() {
        guard CommandLine.arguments.count > 1 else {
            print("Usage: safo <file.md>")
            exit(1)
        }

        let rawPath = CommandLine.arguments[1]
        let absolutePath: String

        if rawPath.hasPrefix("/") {
            absolutePath = rawPath
        } else {
            absolutePath = FileManager.default.currentDirectory + "/" + rawPath
        }

        // Verify file exists
        guard FileManager.default.fileExists(atPath: absolutePath) else {
            print("Error: file not found: \(absolutePath)")
            exit(1)
        }

        // Construct URL scheme
        let encoded = absolutePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? absolutePath
        let url = "safo://open?path=\(encoded)"

        // Open via macOS
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        process.arguments = [url]
        try? process.run()
        process.waitUntilExit()
    }
}
```

**Gotcha:** Always resolve relative paths. The CLI's working directory is the user's
terminal cwd, not the app's.

**Gotcha:** Use `FileManager.default.currentDirectoryPath` (not `currentDirectory`).

---

## 7. Directory Scanning

**Problem:** The sidebar needs all .md files in the current directory and subdirectories.

**Solution:** Use `FileManager.enumerator` with a shallow depth or `contentsOfDirectory`
recursively.

```swift
func scanMarkdownFiles(in directory: URL) -> [URL] {
    let fm = FileManager.default
    guard let enumerator = fm.enumerator(
        at: directory,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]
    ) else { return [] }

    var files: [URL] = []
    for case let fileURL as URL in enumerator {
        if fileURL.pathExtension.lowercased() == "md" {
            files.append(fileURL)
        }
    }
    return files.sorted { $0.path < $1.path }
}
```

**Gotcha:** Skip hidden files (`.skipsHiddenFiles`). Directories like `.git` contain
markdown files you don't want to show.

**Gotcha:** Sort alphabetically for predictable prev/next navigation.

---

## 8. Dark/Light Mode Theme Switching

**Problem:** Safo must adapt all colors to the system appearance.

**Solution:** Use `@Environment(\.colorScheme)` in views and make the Splash code theme
dynamic.

```swift
struct MarkdownContentView: View {
    @Environment(\.colorScheme) var colorScheme

    var codeTheme: Splash.Theme {
        colorScheme == .dark ? CodeTheme.dark : CodeTheme.light
    }

    var body: some View {
        Markdown(content)
            .markdownTheme(.safo)
            .markdownCodeSyntaxHighlighter(
                SplashCodeHighlighter(theme: codeTheme)
            )
    }
}
```

**Gotcha:** MarkdownUI's built-in theme colors use SwiftUI semantic colors that adapt
automatically. But Splash themes use fixed colors, so you need two Splash themes (dark
and light) and switch based on colorScheme.

---

## 9. Copy Feedback

**Problem:** After copying, the user needs brief visual confirmation.

**Solution:** Temporarily change the copy button label from "Copy" to "Copied", then revert.

```swift
@State private var copied = false

Button {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(content, forType: .string)
    copied = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        copied = false
    }
} label: {
    Text(copied ? "Copied" : "Copy")
}
```

**Gotcha:** Use `NSPasteboard` (AppKit), not `UIPasteboard` (UIKit). This is macOS.
