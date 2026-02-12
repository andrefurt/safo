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

- Never commit directly to main.
- Each phase gets its own branch: `feature/phase-1-core-rendering`, `feature/phase-2-navigation`, etc.
- Commit frequently within a phase. Every completed task (or logical chunk) gets a commit.
- Commits: natural language, infinitive tense. "add sidebar navigation", "fix file watcher debounce"
- One logical change per commit.
- At the end of each phase: PR to main, review, merge.

## Quality Gates (mandatory)

After completing each phase, before merging:
1. Invoke `superpowers:verification-before-completion` to verify all tasks are done and working.
2. Invoke `superpowers:requesting-code-review` for code review against standards and roadmap.
3. Only merge after both pass. No exceptions.

## Releases

Two repos: `andrefurt/safo` (source code) and `andrefurt/homebrew-safo` (Homebrew tap).
The tap repo name is a Homebrew convention. Users only see `brew tap andrefurt/safo`.

Release process (automated via GitHub Action):

1. Bump `VERSION` in `Makefile`
2. Commit and push to main
3. Create and push a tag: `git tag v0.2.0 && git push origin v0.2.0`
4. The Action builds, creates a GitHub Release with the zip, and updates the Homebrew cask automatically

Requires `HOMEBREW_TAP_TOKEN` secret in repo settings (PAT with `repo` scope).

Regular commits do NOT trigger releases. Only tag pushes (`v*`) do.

## Key Decisions

- No settings UI. Styles are opinionated and hardcoded.
- No image rendering. Text only.
- No export. Copy markdown source only.
- Single window, single file focus.
- Dark/light follows system. No manual toggle.
