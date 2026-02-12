# Claude Code Hook

Auto-preview markdown files in Safo whenever Claude Code writes or edits a `.md` file.

## Setup

Add this hook to your Claude Code settings. You can configure it at project level (`.claude/settings.json`) or globally (`~/.claude/settings.json`).

### Hook Configuration

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "case \"$CLAUDE_FILE_PATH\" in *.md|*.markdown) safo \"$CLAUDE_FILE_PATH\" ;; esac"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "case \"$CLAUDE_FILE_PATH\" in *.md|*.markdown) safo \"$CLAUDE_FILE_PATH\" ;; esac"
          }
        ]
      }
    ]
  }
}
```

## Prerequisites

The `safo` CLI binary must be in your PATH. After building:

```sh
swift build -c release
cp .build/release/safo-cli /usr/local/bin/safo
```

## How It Works

1. Claude Code writes or edits a file
2. The PostToolUse hook fires after the tool completes
3. The hook checks if the file has a `.md` or `.markdown` extension
4. If it matches, it runs `safo <path>` which opens or navigates the Safo app to that file
5. If Safo is already running, it reuses the existing window (single instance behavior)

## Notes

- The hook only triggers for markdown files. All other file types are ignored.
- The URL scheme (`safo://`) requires the app to be installed as a .app bundle registered with Launch Services. For development builds via `swift build`, pass the file path as a launch argument instead.
- The hook runs asynchronously and does not block Claude Code.
