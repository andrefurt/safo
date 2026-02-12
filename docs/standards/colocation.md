# Code Colocation

> Keep code as close as possible to where it's used.

## Core Rule

- Used in 1 view only: keep in that view file
- Used in 2+ places: move to the appropriate shared location
- "Might be used later": keep colocated until actual reuse

## Decision Tree

### Models
Always centralized: `Models/`

### ViewModels
Always centralized: `ViewModels/`
One ViewModel per major feature, not per view.

### Views
Always in `Views/`
Extract subviews when a view exceeds 100 lines or when a section is logically independent.

### Theme
Always centralized: `Theme/`
All design tokens, markdown theme, and code theme live here.

### Utilities
Always centralized: `Utilities/`
General-purpose helpers that are not view-specific.

### Types
- View-specific types: define in the view file
- Shared types (used in models, ViewModels, or multiple views): `Models/`

### Extensions
- Type-specific extension used in 1 place: colocate
- Broadly useful extension: `Utilities/` with descriptive filename

## File Structure Reference

```
Sources/Safo/
├── SafoApp.swift              # App entry point only
├── AppDelegate.swift          # Window management only
├── Models/                    # Data structures
├── ViewModels/                # Business logic, state
├── Views/                     # UI
├── Theme/                     # Visual tokens and themes
└── Utilities/                 # Helpers, file watching, errors
```

No nested folders beyond this. Keep flat within each folder.
