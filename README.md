# Safo

Native macOS markdown viewer. CLI-first, lightweight, opinionated.

`safo file.md` opens a beautifully rendered preview beside your terminal. File changes update in real time. No config, no settings, no bloat.

## Install

### Homebrew (recommended)

```bash
brew tap andrefurt/safo
brew install --cask safo
```

On first launch, right-click Safo.app > Open (required for ad-hoc signed apps).

### Build from source

Requires Swift 5.9+ and macOS 14 (Sonoma).

```bash
git clone https://github.com/andrefurt/safo.git
cd safo
make install
```

## Usage

```bash
# Open a markdown file
safo README.md

# Open from anywhere
safo ~/docs/notes.md
```

The app opens on the right side of your screen (40% width, full height), designed to sit next to your terminal.

## Features

- Full GFM rendering: headings, bold, italic, strikethrough, links, blockquotes, tables, task lists, code blocks with syntax highlighting
- Real-time file watching: saves update the preview instantly
- Sidebar navigation: browse .md files in the current directory
- Previous/next navigation with keyboard shortcuts
- Copy markdown source to clipboard
- Dark/light mode follows system
- `safo://` URL scheme for integrations
- Claude Code hook support for auto-preview

## Keyboard shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd+]` | Next file |
| `Cmd+[` | Previous file |
| `Cmd+S` | Toggle sidebar |
| `Cmd+Shift+C` | Copy markdown source |

## Stack

- Swift 5.9+, macOS 14+
- SwiftUI (app lifecycle, views, state)
- [MarkdownUI](https://github.com/gonzalezreal/swift-markdown-ui) for rendering
- [Splash](https://github.com/JohnSundell/Splash) for syntax highlighting

## License

MIT
