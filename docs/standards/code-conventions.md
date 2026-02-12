# Code Conventions

> Consistency enables speed. These conventions are non-negotiable.

## Naming

### Files & Folders
| Type | Convention | Example |
|------|-----------|---------|
| Views | `PascalCase.swift` | `ContentView.swift` |
| ViewModels | `PascalCase.swift` | `DocumentViewModel.swift` |
| Models | `PascalCase.swift` | `MarkdownDocument.swift` |
| Theme | `PascalCase.swift` | `SafoTheme.swift` |
| Utilities | `PascalCase.swift` | `FileWatcher.swift` |
| Constants | `PascalCase.swift` | `Tokens.swift` |

### Variables & Functions
| Type | Convention | Example |
|------|-----------|---------|
| Types/Structs/Classes | `PascalCase` | `MarkdownDocument` |
| Functions/Methods | `camelCase` | `scanMarkdownFiles()` |
| Properties | `camelCase` | `currentFile` |
| Constants (global) | `camelCase` in enum namespace | `Tokens.Typography.h1Size` |
| Booleans | `is/has/should/can` prefix | `isLoading`, `hasPrevious` |
| Closures | `on` prefix for callbacks | `onChange`, `onSelect` |
| @Published | descriptive noun | `document`, `sidebarVisible` |

## Swift

- `struct` over `class` unless reference semantics needed (ViewModels are `class`)
- `let` over `var` when value doesn't change
- No force unwraps (`!`). Use `guard let` or optional chaining.
- No `Any`. Use protocols or generics.
- Use `@MainActor` on ViewModels and any code that touches UI state
- Prefer computed properties over methods when no side effects and no parameters
- Use access control: `private` by default, only expose what's needed

## SwiftUI

- Views are structs, always
- Keep views small (under 100 lines). Extract subviews.
- Use `@StateObject` for ViewModel ownership, `@ObservedObject` for passing down
- Use `@Environment` for system values (colorScheme, etc.)
- Prefer `.task` over `.onAppear` for async work
- Never do heavy computation in `body`. Use computed properties or ViewModel.

## Imports

Order: Foundation/SwiftUI > third-party packages > local modules

```swift
import SwiftUI
import MarkdownUI
import Splash
```

## Comments

Explain WHY, not WHAT. No obvious comments. TODO with context:

```swift
// TODO(v2): Support image rendering when MarkdownUI adds lazy loading
```

## Error Handling

- Define errors as enum conforming to `Error`
- Handle errors at the ViewModel level, expose as `@Published var error: SafoError?`
- Views display errors, never handle them
- Never use `try!` or `fatalError` in production paths
