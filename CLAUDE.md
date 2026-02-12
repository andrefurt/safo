# Safo

Native macOS markdown viewer. SwiftUI, CLI-first, lightweight.

## Stack

- Swift 5.9+, macOS 14+ (Sonoma)
- SwiftUI (app lifecycle, views, state)
- Swift Package Manager
- MarkdownUI (gonzalezreal/swift-markdown-ui) for rendering
- Splash (JohnSundell/Splash) for syntax highlighting

## Project Structure

```
Sources/
├── Safo/           # macOS app target
│   ├── Models/
│   ├── ViewModels/
│   ├── Views/
│   ├── Theme/
│   └── Utilities/
└── safo-cli/       # CLI tool target
```

## Rules

- Read `docs/INSTRUCTIONS.md` before writing any code.
- Follow `docs/standards/` conventions strictly.
- Use design tokens from `docs/03-design-tokens.md`. No magic numbers.
- Work through `docs/00-roadmap.md` in order, one task at a time.
- Check `docs/patterns-and-conventions.md` before implementing any pattern.

## Dependencies

Never install or remove dependencies without explicit approval.
Current approved dependencies: MarkdownUI, Splash. Nothing else.

## Git

- Branch convention: feature/, fix/, chore/
- Commits: natural language, infinitive tense. "add sidebar navigation", "fix file watcher debounce"
- Never commit directly to main. Use feature branches.
- One logical change per commit.

## Key Decisions

- No settings UI. Styles are opinionated and hardcoded.
- No image rendering. Text only.
- No export. Copy markdown source only.
- Single window, single file focus.
- Dark/light follows system. No manual toggle.
