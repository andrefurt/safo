# UI Components

## App Layout

```
┌──────────────────────────────────────────────────────────┐
│ Toolbar                                                  │
│ [≡] [< >]  filename.md — path/to/dir         [Copy] │
├────────┬─────────────────────────────────────────────────┤
│Sidebar │  Content                                        │
│        │                                                 │
│ dir/   │  # Heading 1                                    │
│  a.md  │                                                 │
│  b.md  │  Body text with **bold** and *italic*.          │
│ c.md ◀ │                                                 │
│ d.md   │  ```swift                                       │
│        │  let x = 42                                     │
│        │  ```                                            │
│        │                                                 │
│        │  | Col A | Col B |                              │
│        │  |-------|-------|                              │
│        │  | val   | val   |                              │
│        │                                                 │
└────────┴─────────────────────────────────────────────────┘
```

Sidebar is hidden by default. Toggle with the sidebar icon.

## ContentView

**Purpose:** Root view. Manages layout between sidebar and markdown content.

**Structure:**
```
NavigationSplitView (sidebar + detail)
├── SidebarView (when visible)
└── MarkdownContentView
    └── Toolbar (ToolbarItems)
```

**Behavior:**
- Sidebar visibility controlled by `viewModel.sidebarVisible`
- When sidebar is hidden, content fills the full window
- Sidebar appears on the left, pushes content

## ToolbarItems

**Purpose:** Top toolbar with navigation and actions.

**Elements (left to right):**
1. **Sidebar toggle**: icon button, toggles sidebar visibility
2. **Prev/next arrows**: `chevron.left` / `chevron.right`, disabled when at boundary
3. **File info** (center): filename in medium weight, directory path in secondary color below
4. **Copy button** (trailing): copies markdown source to clipboard. Shows brief "Copied" feedback.

**Keyboard shortcuts:**
- `Cmd+[` : previous file
- `Cmd+]` : next file
- `Cmd+Shift+S` : toggle sidebar
- `Cmd+C` (without selection): copy entire file source
- `Cmd+W` or `Escape` : close window / quit

## MarkdownContentView

**Purpose:** Scrollable area with rendered markdown.

**Structure:**
```
ScrollView
└── Markdown(document.content)
    .markdownTheme(SafoTheme)
    .frame(maxWidth: Tokens.Layout.maxContentWidth)
    .padding(horizontal: contentPaddingH, vertical: contentPaddingV)
    .frame(maxWidth: .infinity) // centers content
```

**Behavior:**
- Content is centered horizontally with max width for readability (720pt)
- Scrolls vertically
- When file content changes (file watching), content updates in place
- Scroll position resets when navigating to a different file

## SidebarView

**Purpose:** Minimal file list for navigating .md files in the directory.

**Structure:**
```
List (selection: currentFile)
├── Section (subfolder name) [if files in subfolders]
│   ├── FileRow (filename.md)
│   └── FileRow (filename.md)
└── FileRow (filename.md) [root level files]
```

**FileRow:**
- Shows filename only (not full path)
- Current file is highlighted with accent color
- Click navigates to file

**Grouping:**
- Root-level .md files appear first, ungrouped
- Files in subdirectories are grouped by subfolder name
- Groups are collapsible
- Within each group, files are sorted alphabetically

**Visual:**
- Background: `surfaceElevated`
- Width: `Tokens.Layout.sidebarWidth` (240pt)
- Text: 13pt, regular weight
- Current file: accent color text, subtle background highlight
- No icons (just text, minimal)

## Error States

When an error occurs, the content area shows a centered message:

```
VStack (centered)
├── Text (error title) — secondary color, 15pt medium
└── Text (error detail) — tertiary color, 13pt regular
```

No icons, no dramatic styling. Just clear, quiet information.
