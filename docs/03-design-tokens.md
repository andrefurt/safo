# Design Tokens

All visual values are defined as constants in `Theme/Tokens.swift`. No hardcoded values
anywhere else. Everything adapts to dark/light mode via semantic SwiftUI colors.

## Typography

System fonts only. SF Pro for text, SF Mono for code.

### Headings

| Level | Size | Weight | Tracking | Bottom spacing |
|-------|------|--------|----------|----------------|
| H1 | 32 | .bold | -0.5 | 16 |
| H2 | 26 | .semibold | -0.3 | 14 |
| H3 | 22 | .semibold | 0 | 12 |
| H4 | 18 | .medium | 0 | 10 |
| H5 | 16 | .medium | 0 | 8 |
| H6 | 14 | .medium | 0.5 | 8 |

All headings get `24pt` top spacing (extra breathing room above).
H6 uses secondary text color to differentiate from body at similar size.

### Body

| Element | Size | Weight | Line spacing |
|---------|------|--------|-------------|
| Paragraph | 15 | .regular | 1.65 (factor) |
| Bold | 15 | .semibold | 1.65 |
| Italic | 15 | .regular italic | 1.65 |
| Strikethrough | 15 | .regular | 1.65 |
| Link | 15 | .regular | 1.65 |
| List item | 15 | .regular | 1.65 |
| Blockquote | 15 | .regular | 1.65 |

### Code

| Element | Font | Size | Line spacing |
|---------|------|------|-------------|
| Inline code | SF Mono | 13 | inherits parent |
| Code block | SF Mono | 13 | 1.5 (factor) |

## Colors

Custom colors defined per appearance (dark/light). Source values in OKLCH, implemented as hex in `Tokens.swift` via `NSColor.adaptive()`.

| Token | Light (hex) | Dark (hex) | Light (oklch) | Dark (oklch) | Usage |
|-------|-------------|------------|---------------|--------------|-------|
| `textPrimary` | `#181818` | `#D0D0C8` | `oklch(0.13 0 0)` | `oklch(0.84 0.01 100)` | Body text, headings |
| `textSecondary` | `#21211C` | `#83817D` | `oklch(0.18 0.01 95)` | `oklch(0.58 0.01 85)` | H6, captions, metadata |
| `textTertiary` | system | system | - | - | Placeholder, disabled |
| `background` | `#E8E7E3` | `#181818` | `oklch(0.92 0.01 90)` | `oklch(0.13 0 0)` | Main content background |
| `sidebarBackground` | `#F3F3F1` | `#151514` | `oklch(0.96 0 90)` | `oklch(0.11 0 0)` | Sidebar background |
| `surfaceElevated` | system | system | - | - | Code blocks |
| `accent` | system | system | - | - | Links |
| `separator` | `#FFFFFF` 20% | `#292929` | `oklch(1 0 0 / 0.2)` | `oklch(0.2 0 0)` | Table borders, HR, dividers |
| `selectionBackground` | `#FFFFFF` 30% | `#D0D0C8` 10% | `oklch(1 0 0 / 0.3)` | `oklch(0.84 0.01 100 / 0.1)` | Selected file in sidebar |
| `blockquoteBorder` | `.secondary` 30% | `.secondary` 30% | - | - | Blockquote left border |
| `inlineCodeBackground` | system 30% | system 30% | - | - | Inline code background |

### Code Block Colors (Splash theme)

Dark mode palette (adapts for light):

| Token | Dark value | Usage |
|-------|-----------|-------|
| `codeBackground` | `#1E1E1E` / `#F5F5F5` | Code block background |
| `codePlain` | `#D4D4D4` / `#383838` | Default text |
| `codeKeyword` | `#C586C0` / `#AF00DB` | Keywords |
| `codeString` | `#CE9178` / `#A31515` | Strings |
| `codeType` | `#4EC9B0` / `#267F99` | Type names |
| `codeCall` | `#DCDCAA` / `#795E26` | Function calls |
| `codeNumber` | `#B5CEA8` / `#098658` | Numbers |
| `codeComment` | `#6A9955` / `#008000` | Comments |
| `codeProperty` | `#9CDCFE` / `#001080` | Properties |

## Spacing

| Token | Value | Usage |
|-------|-------|-------|
| `contentPaddingH` | 48 | Horizontal padding of content area |
| `contentPaddingV` | 40 | Top/bottom padding of content area |
| `blockSpacing` | 16 | Space between markdown blocks |
| `headingTopSpacing` | 24 | Extra space above headings |
| `codeBlockPadding` | 16 | Padding inside code blocks |
| `codeBlockRadius` | 8 | Border radius of code blocks |
| `inlineCodePaddingH` | 5 | Horizontal padding of inline code |
| `inlineCodePaddingV` | 2 | Vertical padding of inline code |
| `inlineCodeRadius` | 4 | Border radius of inline code |
| `blockquoteBorderWidth` | 3 | Width of blockquote left border |
| `blockquotePaddingLeft` | 16 | Left padding of blockquote content |
| `tableCellPaddingH` | 12 | Horizontal padding in table cells |
| `tableCellPaddingV` | 8 | Vertical padding in table cells |
| `listIndent` | 24 | Indentation per nesting level |

## Layout

| Token | Value | Usage |
|-------|-------|-------|
| `sidebarWidth` | 240 | Sidebar width when expanded |
| `toolbarHeight` | 44 | Toolbar height |
| `windowWidthRatio` | 0.4 | Initial window width (40% of screen) |
| `maxContentWidth` | 720 | Max width of markdown content (for readability) |

## Animations

| Token | Value | Usage |
|-------|-------|-------|
| `sidebarAnimation` | `.spring(response: 0.3, dampingFraction: 0.88)` | Sidebar toggle |

## Implementation

All tokens live in a single file: `Sources/Safo/Theme/Tokens.swift`

```swift
enum Tokens {
    enum Typography {
        static let h1Size: CGFloat = 32
        // ... all typography tokens
    }
    enum Spacing {
        static let contentPaddingH: CGFloat = 48
        // ... all spacing tokens
    }
    enum Layout {
        static let sidebarWidth: CGFloat = 240
        // ... all layout tokens
    }
}
```

Use `Tokens.Typography.h1Size`, `Tokens.Spacing.blockSpacing`, etc. throughout the app.
Never use magic numbers in views.
