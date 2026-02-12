import SwiftUI

enum Tokens {
    enum Typography {
        // Headings
        static let h1Size: CGFloat = 32
        static let h1Weight: Font.Weight = .bold
        static let h1Tracking: CGFloat = -0.5
        static let h1BottomSpacing: CGFloat = 16

        static let h2Size: CGFloat = 26
        static let h2Weight: Font.Weight = .semibold
        static let h2Tracking: CGFloat = -0.3
        static let h2BottomSpacing: CGFloat = 14

        static let h3Size: CGFloat = 22
        static let h3Weight: Font.Weight = .semibold
        static let h3Tracking: CGFloat = 0
        static let h3BottomSpacing: CGFloat = 12

        static let h4Size: CGFloat = 18
        static let h4Weight: Font.Weight = .medium
        static let h4Tracking: CGFloat = 0
        static let h4BottomSpacing: CGFloat = 10

        static let h5Size: CGFloat = 16
        static let h5Weight: Font.Weight = .medium
        static let h5Tracking: CGFloat = 0
        static let h5BottomSpacing: CGFloat = 8

        static let h6Size: CGFloat = 14
        static let h6Weight: Font.Weight = .medium
        static let h6Tracking: CGFloat = 0.5
        static let h6BottomSpacing: CGFloat = 8

        // Body
        static let bodySize: CGFloat = 15
        static let bodyWeight: Font.Weight = .regular
        static let bodyLineSpacing: CGFloat = 1.65

        static let boldWeight: Font.Weight = .semibold

        // Code
        static let codeSize: CGFloat = 13
        static let codeBlockLineSpacing: CGFloat = 1.5
    }

    enum Spacing {
        static let contentPaddingH: CGFloat = 48
        static let contentPaddingV: CGFloat = 40
        static let blockSpacing: CGFloat = 16
        static let headingTopSpacing: CGFloat = 24
        static let codeBlockPadding: CGFloat = 16
        static let codeBlockRadius: CGFloat = 8
        // MarkdownUI inline TextStyle does not support padding/radius; these tokens
        // are defined per spec for use if the API adds inline container styling.
        static let inlineCodePaddingH: CGFloat = 5
        static let inlineCodePaddingV: CGFloat = 2
        static let inlineCodeRadius: CGFloat = 4
        static let blockquoteBorderWidth: CGFloat = 3
        static let blockquotePaddingLeft: CGFloat = 16
        static let tableCellPaddingH: CGFloat = 12
        static let tableCellPaddingV: CGFloat = 8
        // MarkdownUI handles list indentation internally; token defined per spec
        // for potential future customization.
        static let listIndent: CGFloat = 24
    }

    enum Layout {
        static let sidebarWidth: CGFloat = 240
        static let toolbarHeight: CGFloat = 44
        static let windowWidthRatio: CGFloat = 0.4
        static let maxContentWidth: CGFloat = 720
    }

    enum Colors {
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let textTertiary = Color(nsColor: .tertiaryLabelColor)
        static let background = Color(nsColor: .windowBackgroundColor)
        static let surfaceElevated = Color(nsColor: .controlBackgroundColor)
        static let accent = Color.accentColor
        static let separator = Color(nsColor: .separatorColor)
        static let blockquoteBorder = Color.secondary.opacity(0.3)
        static let inlineCodeBackground = Color(nsColor: .quaternaryLabelColor).opacity(0.3)
    }

    enum CodeColors {
        // Dark mode
        static let darkBackground = Color(hex: 0x1E1E1E)
        static let darkPlain = Color(hex: 0xD4D4D4)
        static let darkKeyword = Color(hex: 0xC586C0)
        static let darkString = Color(hex: 0xCE9178)
        static let darkType = Color(hex: 0x4EC9B0)
        static let darkCall = Color(hex: 0xDCDCAA)
        static let darkNumber = Color(hex: 0xB5CEA8)
        static let darkComment = Color(hex: 0x6A9955)
        static let darkProperty = Color(hex: 0x9CDCFE)

        // Light mode
        static let lightBackground = Color(hex: 0xF5F5F5)
        static let lightPlain = Color(hex: 0x383838)
        static let lightKeyword = Color(hex: 0xAF00DB)
        static let lightString = Color(hex: 0xA31515)
        static let lightType = Color(hex: 0x267F99)
        static let lightCall = Color(hex: 0x795E26)
        static let lightNumber = Color(hex: 0x098658)
        static let lightComment = Color(hex: 0x008000)
        static let lightProperty = Color(hex: 0x001080)
    }

    enum Animation {
        static let sidebar: SwiftUI.Animation = .easeInOut(duration: 0.2)
    }
}

// MARK: - Color hex initializer

extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
