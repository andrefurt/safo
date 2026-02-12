# Context and Decision Reasoning

This document captures the reasoning behind key decisions made during product definition
and build planning. Read this if you need to understand WHY something was decided, not
just WHAT was decided.

## Origin

Safo was born from a specific workflow pain: working in Claude Code (terminal), markdown
files are generated constantly (specs, docs, plans, code reviews), but there's no good way
to read them with rich typography. Terminal renderers like Glow are monospaced and limited.
GUI apps like Typora or Marked 2 are heavy and disconnected from terminal workflow.

The name "Safo" comes from Sappho (Safo in Portuguese), the Greek poet. Chosen because:
it's short (4 chars, works as CLI command), feminine (counterpart to Claude), connected
to writing, and memorable.

## Why SwiftUI native (not Electron, not browser)

Evaluated multiple approaches before landing on SwiftUI:
1. **Shell script + browser HTML**: simplest, but opens browser tabs (noisy)
2. **Quick Look plugin**: native but limited customization
3. **Electron app**: heavy, defeats the "lightweight" requirement
4. **SwiftUI native**: lightweight, fast launch, full control over typography, feels native

SwiftUI was chosen because the target user (macOS developer in terminal) values native
performance and minimal resource usage. The app should feel like a system utility, not
an application.

## Why MarkdownUI library (not custom renderer)

Building a markdown-to-SwiftUI renderer from scratch would take weeks and produce an
inferior result. MarkdownUI (gonzalezreal/swift-markdown-ui) already:
- Parses GFM (tables, task lists, strikethrough)
- Renders to native SwiftUI views (not WebView)
- Supports fully custom themes (fonts, colors, spacing per element)
- Integrates with Splash for syntax highlighting

The tradeoff: dependency on a third-party library. Acceptable because MarkdownUI is
well-maintained, has no transitive dependencies beyond swift-markdown, and the theme
API gives us full visual control.

## Why Splash (not Highlightr, not TreeSitter)

Splash is Swift-native (no JavaScript bridge like Highlightr). It's lightweight and
integrates directly with MarkdownUI's code syntax highlighter protocol. Limitation:
Splash's language support is primarily Swift with basic keyword highlighting for other
languages. Acceptable for v1 since the primary user works in Swift/TypeScript and
perfect highlighting for all languages is not a launch requirement.

## Why URL scheme for CLI communication (not XPC, not sockets)

Three options were evaluated for CLI-to-app communication:
1. **URL scheme** (`safo://open?path=...`): simple, native macOS, works for both
   launching and communicating with running instance
2. **XPC**: more robust but significantly more complex to implement
3. **Distributed notifications**: unreliable for passing data, no guarantee of delivery

URL scheme was chosen for simplicity. The CLI tool just calls `open safo://open?path=...`
and macOS handles launching the app or routing to the running instance. One line of code
in the CLI, one handler in the app.

## Why no settings UI

This is a deliberate product decision, not laziness. The styles are the product's opinion.
Adding customization:
- Increases complexity (UI, persistence, defaults, migration)
- Creates decision fatigue for users who just want to read markdown
- Dilutes the design quality (user choices rarely look as good as curated defaults)

If the typography needs to change, we change it in code. The team uses the same styles.
This aligns with Dieter Rams: the product decides, the user benefits.

## Why single window (not tabs, not multiple windows)

Safo is a companion to the terminal, not a document management app. The mental model is:
"show me this file, now show me that file." One window, one file in focus, sidebar for
quick switching. Tabs add complexity without matching the use case.

If the user runs `safo file.md` while Safo is open, it navigates to the new file in the
same window. This is the expected behavior for a panel/utility app.

## Why 40% width, right side

The terminal occupies the left side of the screen (typically 50-60%). Safo opens on the
right side at 40% width, creating a natural split: terminal left, preview right. This
mirrors the Claude web app's artifact panel behavior that the user referenced as
inspiration.

After initial positioning, the window is freely repositionable and resizable.

## Why file watching is mandatory (not optional)

The core workflow is: Claude Code writes a markdown file, Safo shows it. If the file
updates (Claude is still writing, or the user edits elsewhere), the preview must update
automatically. Manual refresh breaks the flow. File watching with < 200ms latency makes
Safo feel like a live preview, not a static viewer.

## Why dark/light follows system (no manual toggle)

macOS developers typically set their preferred appearance system-wide. Adding a manual
toggle in Safo means maintaining state, adding UI, and creating a situation where Safo
looks different from the rest of the OS. Following the system is the right default for
a utility app.

## Claude Code integration strategy

Two integration modes were defined:

**Mode 1 (core): Hook on file write.** Claude Code supports hooks that trigger on events.
When Claude writes a .md file, a hook runs `safo <path>` automatically. This is the
primary integration and covers the main use case: "document this in a markdown file."

**Mode 2 (future): Render last message.** Sometimes the user wants to read Claude's
terminal response in rich typography without creating a file. This would require saving
the response to a temp .md and opening it. Deferred to post-v1 because it depends on
Claude Code exposing message content to hooks, which needs investigation.

## Scope boundaries

Explicitly excluded from this product (not "later", but "not this product"):
- **Markdown editing**: Safo is read-only. Editing happens in the terminal/editor.
- **Image rendering**: text-only. Markdown in this workflow rarely has images.
- **Cross-platform**: macOS only. The target user is a macOS developer.
- **Public distribution**: internal tool for the Significa team.
- **File browsing beyond root**: sidebar shows files in the opened file's directory
  and subdirectories, never navigates outside.

## Execution model

The build plan is structured so that a new Claude Code session can execute it
autonomously:

1. `CLAUDE.md` is loaded automatically when entering the project directory
2. It points to `docs/INSTRUCTIONS.md` as the first read
3. INSTRUCTIONS.md defines the reading order: standards first, then patterns, then roadmap
4. The roadmap has 36 atomic tasks across 3 phases, each with branch and quality gates
5. Each phase ends with mandatory `verification-before-completion` and `requesting-code-review`

To start execution in a new session:
> "Read docs/INSTRUCTIONS.md and start Phase 1 execution."
