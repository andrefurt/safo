import MarkdownUI
import Splash
import SwiftUI

struct MarkdownContentView: View {
    let content: String

    @Environment(\.colorScheme) private var colorScheme

    private var splashTheme: Splash.Theme {
        colorScheme == .dark ? CodeTheme.dark : CodeTheme.light
    }

    var body: some View {
        ScrollView {
            Markdown(content)
                .markdownTheme(.safo)
                .markdownCodeSyntaxHighlighter(.splash(theme: splashTheme))
                .frame(maxWidth: Tokens.Layout.maxContentWidth, alignment: .leading)
                .padding(.horizontal, Tokens.Spacing.contentPaddingH)
                .padding(.vertical, Tokens.Spacing.contentPaddingV)
                .frame(maxWidth: .infinity)
        }
        .background(Tokens.Colors.background)
    }
}
