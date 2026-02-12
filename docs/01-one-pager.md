# Safo: One-Pager

## What is it?

Safo is a native macOS markdown viewer built with SwiftUI. It opens from the terminal via
`safo file.md`, renders markdown with rich proportional typography, and auto-updates when
files change on disk. It integrates with Claude Code via hooks to auto-open generated markdown.

## What does the app do?

- Renders GFM markdown with beautiful, opinionated typography (proportional fonts, clear
  heading hierarchy, styled tables, syntax-highlighted code blocks)
- Opens as a window on the right side of the screen (40% width, full height)
- Watches the file for changes and updates in real time
- Provides a minimal sidebar to navigate .md files in the current directory and subdirectories
- Copies markdown source to clipboard
- Follows system dark/light mode automatically

## Scope

### Fully functional
- CLI launcher (`safo file.md`)
- Full GFM rendering (headings, bold, italic, strikethrough, links, blockquotes, tables,
  task lists, code blocks with language-specific syntax highlighting, horizontal rules)
- File watching with live update
- Sidebar navigation (toggle, file list, prev/next)
- Copy markdown source
- Dark/light mode (follows system)
- Single window behavior (new file navigates, doesn't open new window)
- Window positioning (40% width, right side, full height)
- Keyboard shortcuts (prev/next, close)

### Not included
- Markdown editing (read-only viewer)
- Image rendering (text only)
- Settings UI (styles are hardcoded, opinionated)
- Export (PDF, HTML)
- Navigation outside the file's root directory
- Multiple windows or tabs
- Cross-platform (macOS only)

## Key Flow

1. User runs `safo README.md` in terminal (or Claude Code hook triggers automatically)
2. Safo opens on the right side of the screen with the file rendered
3. User reads the markdown with rich typography
4. If the file changes (Claude is writing, user edits elsewhere), preview updates live
5. User can toggle sidebar to navigate other .md files in the directory
6. User can copy the markdown source with the copy button
7. Closing the window quits the app

## Links
- **Product Brief:** `docs/PRODUCT-BRIEF.md`
