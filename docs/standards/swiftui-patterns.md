# SwiftUI Patterns

Patterns specific to SwiftUI macOS development in Safo.

## App Lifecycle

Safo uses the SwiftUI App lifecycle with an AppDelegate adapter for window management.

```swift
@main
struct SafoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup { ... }
    }
}
```

Use `@NSApplicationDelegateAdaptor` only for things SwiftUI can't do natively:
window positioning, URL scheme handling at the NSApplication level.

## State Management

### ViewModel Pattern
```
SafoApp (owns @StateObject DocumentViewModel)
└── ContentView (receives @ObservedObject)
    ├── SidebarView (receives @ObservedObject)
    ├── MarkdownContentView (receives @ObservedObject)
    └── ToolbarItems (receives @ObservedObject)
```

One ViewModel (`DocumentViewModel`) owns all app state. Views observe it.
No child ViewModels. No stores. Keep it simple.

### State Ownership Rules
| Property wrapper | When |
|-----------------|------|
| `@StateObject` | Creating the ViewModel (only in SafoApp or ContentView) |
| `@ObservedObject` | Receiving the ViewModel from parent |
| `@State` | View-local UI state (sidebar animation, hover, copied feedback) |
| `@Environment` | System values (colorScheme, dismiss) |
| `@Binding` | Passing mutable state to child without ViewModel |

## Navigation

No router. No NavigationStack. Safo has one screen with an optional sidebar.

Sidebar visibility is a boolean on the ViewModel. File navigation is handled by
the ViewModel (prev/next/goTo). Views just call ViewModel methods.

## Keyboard Shortcuts

Use `.keyboardShortcut` on buttons in the toolbar:

```swift
Button("Previous") { viewModel.navigateToPrevious() }
    .keyboardShortcut("[", modifiers: .command)
```

For global shortcuts not tied to visible buttons, use `.onKeyPress` (macOS 14+)
or add hidden buttons.

## Window Management

Window-level operations (positioning, sizing) go through AppDelegate.
Views never touch NSWindow directly.

```swift
// In AppDelegate
func positionWindow() {
    guard let window = NSApplication.shared.windows.first else { return }
    // position logic
}
```

## Toolbar

Use SwiftUI's `.toolbar` modifier on the main content view:

```swift
.toolbar {
    ToolbarItemGroup(placement: .navigation) {
        // sidebar toggle, prev/next
    }
    ToolbarItem(placement: .principal) {
        // file info
    }
    ToolbarItemGroup(placement: .primaryAction) {
        // copy button
    }
}
```

## Performance

- MarkdownUI re-renders when the content string changes. This is fine for normal files.
  For very large files (10K+ lines), consider debouncing the file watcher reload.
- Don't wrap the Markdown view in unnecessary containers. Keep the view hierarchy shallow.
- Use `Equatable` on models to prevent unnecessary re-renders.
