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

## Distribution

Two repos work together:
- `andrefurt/safo` - source code, releases, GitHub Actions
- `andrefurt/homebrew-safo` - Homebrew tap (cask definition only). Name is a Homebrew convention; users just run `brew tap andrefurt/safo`.

The tap repo is never edited manually. The GitHub Action in safo updates it automatically on each release.

Users install with: `brew tap andrefurt/safo && brew install --cask safo`

## Releases (must follow)

Releases are automated via `.github/workflows/release.yml`. Never create releases manually.

### Steps

1. Bump `VERSION` in `Makefile` (line 1)
2. Commit: `git commit -m "bump version to X.Y.Z"`
3. Merge to main (via PR or direct if small version bump)
4. Tag from main: `git tag vX.Y.Z && git push origin vX.Y.Z`

The tag push triggers the Action, which:
- Builds on macOS 14 (Apple Silicon)
- Runs `make package` (build + bundle + zip)
- Creates a GitHub Release with `Safo-X.Y.Z.zip` attached
- Updates version and SHA-256 in `homebrew-safo/Casks/safo.rb`
- Commits and pushes to homebrew-safo automatically

### Rules

- Tag must match `vX.Y.Z` format (semver with `v` prefix).
- Tag version must match the `VERSION` in `Makefile`. Mismatches break the cask.
- Never edit `homebrew-safo` manually. The Action owns that repo.
- The `HOMEBREW_TAP_TOKEN` secret (PAT with `repo` scope) must exist in safo repo settings. Without it, the cask update step fails silently.
- Regular commits do NOT trigger releases. Only tag pushes do.

### Makefile targets

- `make build` - compile release binaries
- `make bundle` - create signed Safo.app
- `make package` - generate distributable zip (Safo.app + safo CLI)
- `make install` / `make uninstall` - local install to /Applications and /usr/local/bin
- `make clean` - remove build artifacts

## Key Decisions

- No settings UI. Styles are opinionated and hardcoded.
- No image rendering. Text only.
- No export. Copy markdown source only.
- Single window, single file focus.
- Dark/light follows system. No manual toggle.
