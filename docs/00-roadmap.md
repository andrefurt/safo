# Roadmap

## Overview

| Phase | Name | Tasks | Status |
|-------|------|-------|--------|
| 1 | Setup & Core Rendering | 13 | Not started |
| 2 | Navigation & File Operations | 11 | Not started |
| 3 | CLI, Integration & Polish | 9 | Not started |

Total: 33 tasks across 3 phases

---

## Phase 1: Setup & Core Rendering (13 tasks)

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

- [ ] 1.1: Create `Package.swift` with two targets: `Safo` (macOS app, .executableTarget) and `safo-cli` (executable). Add MarkdownUI and Splash as dependencies. Verify `swift build` compiles both targets.

- [ ] 1.2: Create `Sources/Safo/SafoApp.swift` with `@main` App struct, `WindowGroup`, and `@NSApplicationDelegateAdaptor`. Create minimal `ContentView` that shows "Safo" text. Verify app launches.

- [ ] 1.3: Create `Sources/Safo/AppDelegate.swift`. Implement `applicationDidFinishLaunching` to position window: 40% screen width, full height, right side. Use `NSScreen.main.visibleFrame`. See patterns #2.

- [ ] 1.4: Create `Sources/Safo/Theme/Tokens.swift`. Define all design tokens from `03-design-tokens.md`: typography (sizes, weights, tracking), spacing (padding, gaps, radii), layout (sidebar width, max content width, window ratio), colors (semantic SwiftUI colors).

- [ ] 1.5: Create `Sources/Safo/Theme/SafoTheme.swift`. Build custom MarkdownUI `Theme` using tokens. Style paragraphs (15pt, 1.65 line spacing), all 6 heading levels (see token table), blockquotes (left border + padding), lists (indentation + bullet/number styles), horizontal rules, links (accent color), strong/emphasis/strikethrough inline styles, inline code (background pill, monospace). See patterns #0.

- [ ] 1.6: Create `Sources/Safo/Theme/CodeTheme.swift`. Build two Splash `Theme` variants: dark and light. Map all code token colors from `03-design-tokens.md`. Code blocks get background color, rounded corners (8pt radius), padding (16pt). See patterns #1.

- [ ] 1.7: Create `Sources/Safo/Views/MarkdownContentView.swift`. ScrollView with `Markdown(content)` using SafoTheme. Apply code syntax highlighter. Center content with maxWidth (720pt), apply content padding. Switch Splash theme based on `@Environment(\.colorScheme)`. See patterns #8.

- [ ] 1.8: Update `ContentView` to render a comprehensive test markdown string. Include: H1-H6, paragraphs, bold, italic, strikethrough, links, blockquote, unordered list, ordered list, nested list, task list, inline code, code block (Swift), code block (TypeScript), code block (no language), table, horizontal rule. This is the test fixture for visual QA.

- [ ] 1.9: Style tables in SafoTheme: cell padding (12H/8V), separator borders, header row with medium weight text. Verify tables render correctly with the test markdown.

- [ ] 1.10: Verify dark mode rendering. Launch app, toggle system appearance (System Settings or `Cmd+Shift+A` in simulator). All colors must adapt: text, backgrounds, code blocks, borders, links. Fix any hardcoded colors.

- [ ] 1.11: Verify light mode rendering. Same as 1.10 but for light mode. Ensure code block colors switch to light Splash theme. Ensure sufficient contrast on all elements.

- [ ] 1.12: Write Phase 1 summary in this file below.

- [ ] 1.13: Git commit: "phase 1: setup and core markdown rendering with custom theme"

### Phase 1 Summary
_Agent fills this in after completing the phase._

---

## Phase 2: Navigation & File Operations (11 tasks)

**Goal:** App opens a real .md file from disk, watches it for changes, shows sidebar with
directory files, supports prev/next navigation, and copies markdown source.

**Depends on:** Phase 1
**Key docs:** `02-architecture.md`, `04-ui-components.md`

### Gotchas
- See patterns #3 (file watching) — editors like vim rename files on save
- See patterns #7 (directory scanning) — skip hidden files
- See patterns #9 (copy feedback)

### Tasks

- [ ] 2.1: Create `Sources/Safo/Models/MarkdownDocument.swift`. Implement the model from `02-architecture.md`: id (URL), url, content, lastModified, computed fileName and relativePath. Add static method `load(from: URL) throws -> MarkdownDocument` that reads file content.

- [ ] 2.2: Create `Sources/Safo/Models/DirectoryListing.swift`. Implement from `02-architecture.md`: rootURL, files array, currentIndex. Methods: `goToNext()`, `goToPrevious()`, `goTo(url:)`. Static method `scan(directory: URL) -> DirectoryListing` that finds all .md files recursively, sorted alphabetically, skipping hidden files. See patterns #7.

- [ ] 2.3: Create `Sources/Safo/Utilities/FileWatcher.swift`. DispatchSource-based file watcher. Watch for write, rename, delete events. Include debouncing (100ms). Re-create watcher on rename/delete. See patterns #3.

- [ ] 2.4: Create `Sources/Safo/Utilities/SafoError.swift`. Define error enum: `fileNotFound(String)`, `notMarkdownFile(String)`, `permissionDenied(String)`, `emptyFile`, `fileDeleted`.

- [ ] 2.5: Create `Sources/Safo/ViewModels/DocumentViewModel.swift`. Implement from `02-architecture.md`: @Published document, directoryListing, sidebarVisible, error. Methods: open(url:), navigateToNext(), navigateToPrevious(), navigateTo(url:), copyToClipboard(), toggleSidebar(). Wire up FileWatcher on open. Handle all error cases.

- [ ] 2.6: Update `SafoApp.swift` to create `@StateObject DocumentViewModel`. Pass as `@ObservedObject` to `ContentView`. For now, accept a hardcoded file path for testing (will be replaced by CLI in Phase 3).

- [ ] 2.7: Update `ContentView` to use ViewModel. Show `MarkdownContentView` with `document.content`. Show error view when `error` is set. Replace hardcoded test markdown with real file content.

- [ ] 2.8: Create `Sources/Safo/Views/SidebarView.swift`. List of .md files from `directoryListing`. Group by subfolder. Highlight current file. Click navigates. See `04-ui-components.md` for spec. Use `NavigationSplitView` or conditional sidebar with animation.

- [ ] 2.9: Create `Sources/Safo/Views/ToolbarItems.swift`. Implement toolbar: sidebar toggle (leading), prev/next arrows with disabled states (leading), file info center (filename + path), copy button (trailing). Add keyboard shortcuts: `Cmd+[`, `Cmd+]`, `Cmd+Shift+S`. See patterns #9 for copy feedback.

- [ ] 2.10: Write Phase 2 summary in this file below.

- [ ] 2.11: Git commit: "phase 2: file operations, sidebar navigation, file watching"

### Phase 2 Summary
_Agent fills this in after completing the phase._

---

## Phase 3: CLI, Integration & Polish (9 tasks)

**Goal:** `safo file.md` works from terminal. Single instance behavior. Claude Code hook
documented. All edge cases handled. App is usable for daily work.

**Depends on:** Phase 2
**Key docs:** `02-architecture.md`

### Gotchas
- See patterns #4 (URL scheme), #5 (single instance), #6 (CLI tool)
- Path encoding is critical: spaces and special characters in file paths

### Tasks

- [ ] 3.1: Create `Resources/Info.plist` with URL scheme registration (`safo://`). Add `CFBundleURLTypes` with scheme `safo` and name `com.significa.safo`. Set `LSUIElement` to false (visible in dock when running).

- [ ] 3.2: Update `SafoApp.swift` with `.onOpenURL` handler. Parse `safo://open?path=...` URL, extract path, call `viewModel.open(url:)`. Also handle launch arguments: if `CommandLine.arguments` contains a file path, open it on launch. See patterns #4.

- [ ] 3.3: Implement single instance behavior. Add `.handlesExternalEvents(matching:)` to WindowGroup so new URLs navigate in the existing window instead of opening a new one. See patterns #5.

- [ ] 3.4: Create `Sources/safo-cli/SafoCLI.swift`. Accept file path argument, resolve to absolute path, verify file exists and is .md, construct `safo://` URL, open via `Process` calling `/usr/bin/open`. See patterns #6. Handle errors: no argument, file not found, not .md.

- [ ] 3.5: Test end-to-end CLI flow. Build both targets. Run `safo test.md` from terminal. Verify: app opens, file renders, window positions correctly. Run again with different file. Verify: same window navigates to new file.

- [ ] 3.6: Handle edge cases. Test and fix: file not found (show error), empty file (show "Empty file" message), file deleted while viewing (show "File was deleted", stop watcher), non-.md file from CLI (show error), file with special characters in path (spaces, unicode).

- [ ] 3.7: Create `docs/claude-code-hook.md`. Document how to configure a Claude Code hook that auto-opens Safo when a .md file is written. Include the hook configuration JSON and installation instructions.

- [ ] 3.8: Write Phase 3 summary in this file below.

- [ ] 3.9: Git commit: "phase 3: CLI tool, URL scheme, single instance, edge cases"

### Phase 3 Summary
_Agent fills this in after completing the phase._
