# Instructions for AI Assistant

You are building **Safo**, a native macOS markdown viewer app in SwiftUI. Safo is a read-only
viewer that opens from the terminal via `safo file.md`, renders markdown with rich typography,
and integrates with Claude Code via hooks.

## Project Context

Safo solves a workflow gap: developers using Claude Code generate markdown constantly but have no
lightweight, native way to preview it with rich typography. Terminal renderers (Glow, mdcat) are
monospaced. GUI apps (Typora, Marked 2) are heavy and disconnected from the terminal. Safo is
CLI-first, native SwiftUI, and designed for the generate-preview-iterate loop.

**Tech Stack:**
- Swift 5.9+, macOS 14+ (Sonoma)
- SwiftUI (app lifecycle, views, state management)
- Swift Package Manager (dependencies, build)
- MarkdownUI (gonzalezreal/swift-markdown-ui) for markdown rendering
- Splash (JohnSundell/Splash) for syntax highlighting
- No backend. No network calls. Local files only.

## Documentation Structure

```
docs/
├── INSTRUCTIONS.md                    # You are here
├── 00-roadmap.md                      # Phased task list
├── 01-one-pager.md                    # Project overview and scope
├── 02-architecture.md                 # Architecture, models, file structure
├── 03-design-tokens.md                # Typography, colors, spacing
├── 04-ui-components.md                # SwiftUI view specifications
├── patterns-and-conventions.md        # Implementation patterns and gotchas
├── standards/
│   ├── code-conventions.md            # Swift naming, style, patterns
│   ├── colocation.md                  # Where to put code
│   └── swiftui-patterns.md            # SwiftUI-specific patterns
└── PRODUCT-BRIEF.md                   # Product definition (reference only)
```

## Required Reading (In Order)

### Before Writing ANY Code
1. `docs/standards/code-conventions.md`
2. `docs/standards/colocation.md`
3. `docs/standards/swiftui-patterns.md`
4. `docs/03-design-tokens.md`

### Before Each Phase
1. `docs/patterns-and-conventions.md`: known solutions to known problems
2. `docs/00-roadmap.md`: current task
3. Relevant spec files for the phase

## Working with the Roadmap

### Branching (mandatory)
1. Each phase lives on its own branch: `feature/phase-1-core-rendering`, `feature/phase-2-navigation`, `feature/phase-3-cli-integration`.
2. Create the branch from `main` before starting the phase.
3. Commit frequently: every completed task (or meaningful chunk of work) gets a commit.
4. At the end of each phase: PR to main, review, merge. Then branch the next phase from updated main.

### Rules
1. Work in order. Complete Phase 1 before Phase 2.
2. One task at a time.
3. Mark tasks as done: `[ ]` to `[x]`.
4. Write phase summaries after completing all tasks in a phase.
5. Commit after every completed task. Do not batch multiple tasks into one commit.

### Task Completion Checklist
- [ ] Code compiles without errors (`swift build`)
- [ ] Feature works as described
- [ ] Follows standards in `docs/standards/`
- [ ] Uses design tokens (no hardcoded values)
- [ ] Dark and light mode both render correctly

### Quality Gates (mandatory, after each phase)
Before merging a phase branch to main, you MUST:
1. Invoke `superpowers:verification-before-completion` to confirm all tasks work and compile.
2. Invoke `superpowers:requesting-code-review` for a code review against standards and roadmap.
3. Only merge after both pass. No exceptions. Evidence before assertions.

### If You Get Stuck
1. Check `patterns-and-conventions.md` for known solutions
2. Document what's blocking in the roadmap
3. Move to the next task
4. Come back at end of phase

## Starting Point
1. Read ALL files in `docs/standards/`
2. Read `docs/patterns-and-conventions.md`
3. Read `docs/00-roadmap.md`
4. Start Phase 1, Task 1.1
