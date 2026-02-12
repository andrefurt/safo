# Roadmap

## Overview

| Phase | Name | Branch | Tasks | Status |
|-------|------|--------|-------|--------|
| 1 | Setup & Core Rendering | `feature/phase-1-core-rendering` | 14 | Complete |
| 2 | Navigation & File Operations | `feature/phase-2-navigation` | 12 | Complete |
| 3 | CLI, Integration & Polish | `feature/phase-3-cli-integration` | 10 | Complete |

Total: 36 tasks across 3 phases

---

## Phase 1: Setup & Core Rendering (13 tasks)

**Branch:** `feature/phase-1-core-rendering` (from `main`)

**Goal:** App launches, renders a hardcoded markdown string with full custom theme
(typography, colors, code highlighting), adapts to dark/light mode. Window positions
correctly on the right side.

**Depends on:** Nothing
**Key docs:** `02-architecture.md`, `03-design-tokens.md`, `04-ui-components.md`

### Gotchas
- See patterns #0 (MarkdownUI theme) and #1 (Splash integration)
- See patterns #2 (window positioning)
- See patterns #8 (dark/light mode)

### Tasks

- [x] 1.1: Create `Package.swift` with two targets: `Safo` (macOS app, .executableTarget) and `safo-cli` (executable). Add MarkdownUI and Splash as dependencies. Verify `swift build` compiles both targets.

- [x] 1.2: Create `Sources/Safo/SafoApp.swift` with `@main` App struct, `WindowGroup`, and `@NSApplicationDelegateAdaptor`. Create minimal `ContentView` that shows "Safo" text. Verify app launches.

- [x] 1.3: Create `Sources/Safo/AppDelegate.swift`. Implement `applicationDidFinishLaunching` to position window: 40% screen width, full height, right side. Use `NSScreen.main.visibleFrame`. See patterns #2.

- [x] 1.4: Create `Sources/Safo/Theme/Tokens.swift`. Define all design tokens from `03-design-tokens.md`: typography (sizes, weights, tracking), spacing (padding, gaps, radii), layout (sidebar width, max content width, window ratio), colors (semantic SwiftUI colors).

- [x] 1.5: Create `Sources/Safo/Theme/SafoTheme.swift`. Build custom MarkdownUI `Theme` using tokens. Style paragraphs (15pt, 1.65 line spacing), all 6 heading levels (see token table), blockquotes (left border + padding), lists (indentation + bullet/number styles), horizontal rules, links (accent color), strong/emphasis/strikethrough inline styles, inline code (background pill, monospace). See patterns #0.

- [x] 1.6: Create `Sources/Safo/Theme/CodeTheme.swift`. Build two Splash `Theme` variants: dark and light. Map all code token colors from `03-design-tokens.md`. Code blocks get background color, rounded corners (8pt radius), padding (16pt). See patterns #1.

- [x] 1.7: Create `Sources/Safo/Views/MarkdownContentView.swift`. ScrollView with `Markdown(content)` using SafoTheme. Apply code syntax highlighter. Center content with maxWidth (720pt), apply content padding. Switch Splash theme based on `@Environment(\.colorScheme)`. See patterns #8.

- [x] 1.8: Update `ContentView` to render a comprehensive test markdown string. Include: H1-H6, paragraphs, bold, italic, strikethrough, links, blockquote, unordered list, ordered list, nested list, task list, inline code, code block (Swift), code block (TypeScript), code block (no language), table, horizontal rule. This is the test fixture for visual QA.

- [x] 1.9: Style tables in SafoTheme: cell padding (12H/8V), separator borders, header row with medium weight text. Verify tables render correctly with the test markdown.

- [x] 1.10: Verify dark mode rendering. Launch app, toggle system appearance (System Settings or `Cmd+Shift+A` in simulator). All colors must adapt: text, backgrounds, code blocks, borders, links. Fix any hardcoded colors.

- [x] 1.11: Verify light mode rendering. Same as 1.10 but for light mode. Ensure code block colors switch to light Splash theme. Ensure sufficient contrast on all elements.

- [x] 1.12: Write Phase 1 summary in this file below.

- [x] 1.13: Run quality gates: invoke `superpowers:verification-before-completion`, then `superpowers:requesting-code-review`. Fix any issues found.

- [x] 1.14: Final commit, PR to main, merge after review passes.

### Phase 1 Summary

Phase 1 established the project foundation and core rendering pipeline.

**What was built:**
- `Package.swift` with two targets (Safo app, safo-cli) and dependencies (MarkdownUI 2.4.1, Splash 0.16.0)
- SwiftUI app lifecycle with `@NSApplicationDelegateAdaptor` for window positioning (40% width, right side, full height)
- Complete design token system (`Tokens.swift`) covering typography, spacing, layout, colors, code colors, and animation values
- Custom MarkdownUI theme (`SafoTheme.swift`) styling all block and inline elements: 6 heading levels with distinct sizes/weights/tracking, paragraphs with 1.65 line spacing, blockquotes with left border, styled tables, lists, horizontal rules, links, strong/emphasis/strikethrough, and inline code
- Splash-based code syntax highlighting (`CodeTheme.swift`) with dark and light variants, wired into MarkdownUI via `CodeSyntaxHighlighter` protocol
- `MarkdownContentView` with scrollable, centered (720pt max), padded content that switches Splash theme based on system color scheme
- Comprehensive test markdown fixture covering all supported elements

**Architecture decisions:**
- Used absolute font sizes in theme (not relative em units) since the design spec defines exact point sizes
- Splash `TextOutputFormat` adapted for macOS (NSColor instead of UIColor)
- Code theme switching driven by `@Environment(\.colorScheme)` for automatic dark/light adaptation
- All colors are semantic SwiftUI colors or token-defined, no hardcoded values in views

**Files created (9):**
- `Package.swift`
- `Sources/Safo/SafoApp.swift`
- `Sources/Safo/AppDelegate.swift`
- `Sources/Safo/Theme/Tokens.swift`
- `Sources/Safo/Theme/SafoTheme.swift`
- `Sources/Safo/Theme/CodeTheme.swift`
- `Sources/Safo/Views/ContentView.swift`
- `Sources/Safo/Views/MarkdownContentView.swift`
- `Sources/safo-cli/SafoCLI.swift`

---

## Phase 2: Navigation & File Operations (12 tasks)

**Branch:** `feature/phase-2-navigation` (from updated `main` after Phase 1 merge)

**Goal:** App opens a real .md file from disk, watches it for changes, shows sidebar with
directory files, supports prev/next navigation, and copies markdown source.

**Depends on:** Phase 1
**Key docs:** `02-architecture.md`, `04-ui-components.md`

### Gotchas
- See patterns #3 (file watching) — editors like vim rename files on save
- See patterns #7 (directory scanning) — skip hidden files
- See patterns #9 (copy feedback)

### Tasks

- [x] 2.1: Create `Sources/Safo/Models/MarkdownDocument.swift`. Implement the model from `02-architecture.md`: id (URL), url, content, lastModified, computed fileName and relativePath. Add static method `load(from: URL) throws -> MarkdownDocument` that reads file content.

- [x] 2.2: Create `Sources/Safo/Models/DirectoryListing.swift`. Implement from `02-architecture.md`: rootURL, files array, currentIndex. Methods: `goToNext()`, `goToPrevious()`, `goTo(url:)`. Static method `scan(directory: URL) -> DirectoryListing` that finds all .md files recursively, sorted alphabetically, skipping hidden files. See patterns #7.

- [x] 2.3: Create `Sources/Safo/Utilities/FileWatcher.swift`. DispatchSource-based file watcher. Watch for write, rename, delete events. Include debouncing (100ms). Re-create watcher on rename/delete. See patterns #3.

- [x] 2.4: Create `Sources/Safo/Utilities/SafoError.swift`. Define error enum: `fileNotFound(String)`, `notMarkdownFile(String)`, `permissionDenied(String)`, `emptyFile`, `fileDeleted`.

- [x] 2.5: Create `Sources/Safo/ViewModels/DocumentViewModel.swift`. Implement from `02-architecture.md`: @Published document, directoryListing, sidebarVisible, error. Methods: open(url:), navigateToNext(), navigateToPrevious(), navigateTo(url:), copyToClipboard(), toggleSidebar(). Wire up FileWatcher on open. Handle all error cases.

- [x] 2.6: Update `SafoApp.swift` to create `@StateObject DocumentViewModel`. Pass as `@ObservedObject` to `ContentView`. For now, accept a hardcoded file path for testing (will be replaced by CLI in Phase 3).

- [x] 2.7: Update `ContentView` to use ViewModel. Show `MarkdownContentView` with `document.content`. Show error view when `error` is set. Replace hardcoded test markdown with real file content.

- [x] 2.8: Create `Sources/Safo/Views/SidebarView.swift`. List of .md files from `directoryListing`. Group by subfolder. Highlight current file. Click navigates. See `04-ui-components.md` for spec. Use `NavigationSplitView` or conditional sidebar with animation.

- [x] 2.9: Create `Sources/Safo/Views/ToolbarItems.swift`. Implement toolbar: sidebar toggle (leading), prev/next arrows with disabled states (leading), file info center (filename + path), copy button (trailing). Add keyboard shortcuts: `Cmd+[`, `Cmd+]`, `Cmd+Shift+S`. See patterns #9 for copy feedback.

- [x] 2.10: Write Phase 2 summary in this file below.

- [x] 2.11: Run quality gates: invoke `superpowers:verification-before-completion`, then `superpowers:requesting-code-review`. Fix any issues found.

- [x] 2.12: Final commit, PR to main, merge after review passes.

### Phase 2 Summary

Phase 2 added file operations and navigation, making Safo a functional markdown viewer.

**What was built:**
- `MarkdownDocument` model with file loading, error handling, and modification date tracking
- `DirectoryListing` model with recursive `.md` file scanning (skips hidden files), alphabetical sorting, and prev/next/goTo navigation
- `FileWatcher` using DispatchSource for live file monitoring with 100ms debounce and vim-compatible rename/delete handling (re-creates watcher when file is replaced)
- `SafoError` enum covering all error states: file not found, not markdown, permission denied, empty file, file deleted
- `DocumentViewModel` as the single source of truth: file loading, directory scanning, navigation, clipboard, sidebar toggle, and FileWatcher lifecycle management
- `SidebarView` with grouped file list (root files first, then by subfolder), accent-highlighted current file, and click-to-navigate
- `ToolbarItems` with sidebar toggle (`Cmd+Shift+S`), prev/next arrows (`Cmd+[`/`Cmd+]`) with disabled states, centered file info (name + relative path), and copy button with 1.5s "Copied" feedback
- Error and empty states in ContentView with quiet, centered messaging
- `NavigationSplitView` layout with `.prominentDetail` style for sidebar/content split

**Architecture decisions:**
- `relativePath` implemented as a method taking `rootURL` parameter (rather than stored property) to keep the model decoupled from directory context
- Navigation (`navigateToNext/Previous/To`) skips directory rescanning, only `open(url:)` rescans (avoids double @Published writes)
- `withAnimation(Tokens.Animation.sidebar)` applied in ViewModel's `toggleSidebar()` for consistent animation
- `attributesOfItem` uses `try?` fallback since modification date is non-critical
- Added dedicated typography tokens for sidebar (13pt) and toolbar (13pt title, 11pt subtitle) to avoid magic numbers

**Files created (7):**
- `Sources/Safo/Models/MarkdownDocument.swift`
- `Sources/Safo/Models/DirectoryListing.swift`
- `Sources/Safo/Utilities/SafoError.swift`
- `Sources/Safo/Utilities/FileWatcher.swift`
- `Sources/Safo/ViewModels/DocumentViewModel.swift`
- `Sources/Safo/Views/SidebarView.swift`
- `Sources/Safo/Views/ToolbarItems.swift`

**Files modified (4):**
- `Sources/Safo/SafoApp.swift` (added ViewModel, launch args)
- `Sources/Safo/Views/ContentView.swift` (NavigationSplitView, error/empty states, toolbar)
- `Sources/Safo/Theme/Tokens.swift` (added sidebar, toolbar, error state tokens)
- `docs/00-roadmap.md` (this summary)

---

## Phase 3: CLI, Integration & Polish (10 tasks)

**Branch:** `feature/phase-3-cli-integration` (from updated `main` after Phase 2 merge)

**Goal:** `safo file.md` works from terminal. Single instance behavior. Claude Code hook
documented. All edge cases handled. App is usable for daily work.

**Depends on:** Phase 2
**Key docs:** `02-architecture.md`

### Gotchas
- See patterns #4 (URL scheme), #5 (single instance), #6 (CLI tool)
- Path encoding is critical: spaces and special characters in file paths

### Tasks

- [x] 3.1: Create `Resources/Info.plist` with URL scheme registration (`safo://`). Add `CFBundleURLTypes` with scheme `safo` and name `com.significa.safo`. Set `LSUIElement` to false (visible in dock when running).

- [x] 3.2: Update `SafoApp.swift` with `.onOpenURL` handler. Parse `safo://open?path=...` URL, extract path, call `viewModel.open(url:)`. Also handle launch arguments: if `CommandLine.arguments` contains a file path, open it on launch. See patterns #4.

- [x] 3.3: Implement single instance behavior. Add `.handlesExternalEvents(matching:)` to WindowGroup so new URLs navigate in the existing window instead of opening a new one. See patterns #5.

- [x] 3.4: Create `Sources/safo-cli/SafoCLI.swift`. Accept file path argument, resolve to absolute path, verify file exists and is .md, construct `safo://` URL, open via `Process` calling `/usr/bin/open`. See patterns #6. Handle errors: no argument, file not found, not .md.

- [x] 3.5: Test end-to-end CLI flow. Build both targets. Run `safo test.md` from terminal. Verify: app opens, file renders, window positions correctly. Run again with different file. Verify: same window navigates to new file.

- [x] 3.6: Handle edge cases. Test and fix: file not found (show error), empty file (show "Empty file" message), file deleted while viewing (show "File was deleted", stop watcher), non-.md file from CLI (show error), file with special characters in path (spaces, unicode).

- [x] 3.7: Create `docs/claude-code-hook.md`. Document how to configure a Claude Code hook that auto-opens Safo when a .md file is written. Include the hook configuration JSON and installation instructions.

- [x] 3.8: Write Phase 3 summary in this file below.

- [ ] 3.9: Run quality gates: invoke `superpowers:verification-before-completion`, then `superpowers:requesting-code-review`. Fix any issues found.

- [ ] 3.10: Final commit, PR to main, merge after review passes.

### Phase 3 Summary

Phase 3 completed the CLI tool and integration layer, making Safo usable from the terminal.

**What was built:**
- `Resources/Info.plist` with `safo://` URL scheme registration (`CFBundleURLTypes`), `LSUIElement` false, and termination control flags
- `.onOpenURL` handler in `SafoApp.swift` parsing `safo://open?path=...` URLs with percent-decoded path extraction
- Single instance behavior via `.handlesExternalEvents(matching: Set(arrayLiteral: "*"))` routing all external events to the existing window
- Full CLI tool (`SafoCLI.swift`) with path resolution (relative, tilde, absolute), file existence and extension validation, URL construction with percent-encoding, and error reporting to stderr
- `.markdown` extension support added to `MarkdownDocument.load` (aligned with CLI)
- Claude Code hook documentation (`docs/claude-code-hook.md`) with PostToolUse configuration for auto-preview on Write/Edit of markdown files

**Architecture decisions:**
- CLI uses `/usr/bin/open` with URL scheme for app communication (works for both launching and sending to running instance)
- Path resolution handles relative paths via `FileManager.currentDirectoryPath`, tilde via `NSString.expandingTildeInPath`, and normalizes via `URL.standardized`
- Errors written to stderr (not stdout) following Unix conventions
- URL scheme requires .app bundle registration with Launch Services; launch arguments serve as fallback for development builds
- `NSSupportsAutomaticTermination` and `NSSupportsSuddenTermination` set to false for predictable lifecycle

**Files created (2):**
- `Resources/Info.plist`
- `docs/claude-code-hook.md`

**Files modified (3):**
- `Sources/Safo/SafoApp.swift` (onOpenURL, handlesExternalEvents, launch args)
- `Sources/Safo/Models/MarkdownDocument.swift` (.markdown extension support)
- `Sources/safo-cli/SafoCLI.swift` (full implementation replacing placeholder)
