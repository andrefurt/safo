import MarkdownUI
import Splash
import SwiftUI

// MARK: - Splash theme definitions

enum CodeTheme {
    static let dark = Splash.Theme(
        font: Splash.Font(size: Double(Tokens.Typography.codeSize)),
        plainTextColor: NSColor(Tokens.CodeColors.darkPlain),
        tokenColors: [
            .keyword: NSColor(Tokens.CodeColors.darkKeyword),
            .string: NSColor(Tokens.CodeColors.darkString),
            .type: NSColor(Tokens.CodeColors.darkType),
            .call: NSColor(Tokens.CodeColors.darkCall),
            .number: NSColor(Tokens.CodeColors.darkNumber),
            .comment: NSColor(Tokens.CodeColors.darkComment),
            .property: NSColor(Tokens.CodeColors.darkProperty),
            .dotAccess: NSColor(Tokens.CodeColors.darkProperty),
            .preprocessing: NSColor(Tokens.CodeColors.darkKeyword),
        ],
        backgroundColor: NSColor(Tokens.CodeColors.darkBackground)
    )

    static let light = Splash.Theme(
        font: Splash.Font(size: Double(Tokens.Typography.codeSize)),
        plainTextColor: NSColor(Tokens.CodeColors.lightPlain),
        tokenColors: [
            .keyword: NSColor(Tokens.CodeColors.lightKeyword),
            .string: NSColor(Tokens.CodeColors.lightString),
            .type: NSColor(Tokens.CodeColors.lightType),
            .call: NSColor(Tokens.CodeColors.lightCall),
            .number: NSColor(Tokens.CodeColors.lightNumber),
            .comment: NSColor(Tokens.CodeColors.lightComment),
            .property: NSColor(Tokens.CodeColors.lightProperty),
            .dotAccess: NSColor(Tokens.CodeColors.lightProperty),
            .preprocessing: NSColor(Tokens.CodeColors.lightKeyword),
        ],
        backgroundColor: NSColor(Tokens.CodeColors.lightBackground)
    )
}

// MARK: - Splash to SwiftUI Text output format

private struct TextOutputFormat: OutputFormat {
    private let theme: Splash.Theme

    init(theme: Splash.Theme) {
        self.theme = theme
    }

    func makeBuilder() -> Builder {
        Builder(theme: theme)
    }
}

extension TextOutputFormat {
    struct Builder: OutputBuilder {
        private let theme: Splash.Theme
        private var accumulatedText: [Text]

        fileprivate init(theme: Splash.Theme) {
            self.theme = theme
            self.accumulatedText = []
        }

        mutating func addToken(_ token: String, ofType type: TokenType) {
            let color = theme.tokenColors[type] ?? theme.plainTextColor
            accumulatedText.append(Text(token).foregroundColor(SwiftUI.Color(nsColor: color)))
        }

        mutating func addPlainText(_ text: String) {
            accumulatedText.append(
                Text(text).foregroundColor(SwiftUI.Color(nsColor: theme.plainTextColor))
            )
        }

        mutating func addWhitespace(_ whitespace: String) {
            accumulatedText.append(Text(whitespace))
        }

        func build() -> Text {
            accumulatedText.reduce(Text(""), +)
        }
    }
}

// MARK: - MarkdownUI code syntax highlighter

struct SplashCodeHighlighter: CodeSyntaxHighlighter {
    private let syntaxHighlighter: SyntaxHighlighter<TextOutputFormat>

    init(theme: Splash.Theme) {
        self.syntaxHighlighter = SyntaxHighlighter(format: TextOutputFormat(theme: theme))
    }

    func highlightCode(_ code: String, language: String?) -> Text {
        guard language != nil else {
            return Text(code)
        }
        return syntaxHighlighter.highlight(code)
    }
}

extension CodeSyntaxHighlighter where Self == SplashCodeHighlighter {
    static func splash(theme: Splash.Theme) -> Self {
        SplashCodeHighlighter(theme: theme)
    }
}
