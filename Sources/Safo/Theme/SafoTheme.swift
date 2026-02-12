import MarkdownUI
import SwiftUI

extension Theme {
    static let safo = Theme()
        .text {
            ForegroundColor(Tokens.Colors.textPrimary)
            FontSize(Tokens.Typography.bodySize)
        }
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(Tokens.Typography.codeSize)
            BackgroundColor(Tokens.Colors.inlineCodeBackground)
        }
        .strong {
            FontWeight(Tokens.Typography.boldWeight)
        }
        .emphasis {
            FontStyle(.italic)
        }
        .strikethrough {
            StrikethroughStyle(.single)
        }
        .link {
            ForegroundColor(Tokens.Colors.accent)
        }
        .heading1 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: Tokens.Typography.headingTopSpacing, bottom: Tokens.Typography.h1BottomSpacing)
                .markdownTextStyle {
                    FontWeight(Tokens.Typography.h1Weight)
                    FontSize(Tokens.Typography.h1Size)
                    TextTracking(Tokens.Typography.h1Tracking)
                }
        }
        .heading2 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: Tokens.Typography.headingTopSpacing, bottom: Tokens.Typography.h2BottomSpacing)
                .markdownTextStyle {
                    FontWeight(Tokens.Typography.h2Weight)
                    FontSize(Tokens.Typography.h2Size)
                    TextTracking(Tokens.Typography.h2Tracking)
                }
        }
        .heading3 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: Tokens.Typography.headingTopSpacing, bottom: Tokens.Typography.h3BottomSpacing)
                .markdownTextStyle {
                    FontWeight(Tokens.Typography.h3Weight)
                    FontSize(Tokens.Typography.h3Size)
                }
        }
        .heading4 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: Tokens.Typography.headingTopSpacing, bottom: Tokens.Typography.h4BottomSpacing)
                .markdownTextStyle {
                    FontWeight(Tokens.Typography.h4Weight)
                    FontSize(Tokens.Typography.h4Size)
                }
        }
        .heading5 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: Tokens.Typography.headingTopSpacing, bottom: Tokens.Typography.h5BottomSpacing)
                .markdownTextStyle {
                    FontWeight(Tokens.Typography.h5Weight)
                    FontSize(Tokens.Typography.h5Size)
                }
        }
        .heading6 { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.125))
                .markdownMargin(top: Tokens.Typography.headingTopSpacing, bottom: Tokens.Typography.h6BottomSpacing)
                .markdownTextStyle {
                    FontWeight(Tokens.Typography.h6Weight)
                    FontSize(Tokens.Typography.h6Size)
                    TextTracking(Tokens.Typography.h6Tracking)
                    ForegroundColor(Tokens.Colors.textSecondary)
                }
        }
        .paragraph { configuration in
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .relativeLineSpacing(.em(0.65))
                .markdownMargin(top: 0, bottom: Tokens.Spacing.blockSpacing)
        }
        .blockquote { configuration in
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Tokens.Colors.blockquoteBorder)
                    .frame(width: Tokens.Spacing.blockquoteBorderWidth)
                configuration.label
                    .markdownTextStyle {
                        ForegroundColor(Tokens.Colors.textSecondary)
                    }
                    .padding(.leading, Tokens.Spacing.blockquotePaddingLeft)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .codeBlock { configuration in
            ScrollView(.horizontal) {
                configuration.label
                    .fixedSize(horizontal: false, vertical: true)
                    .relativeLineSpacing(.em(0.5))
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(Tokens.Typography.codeSize)
                    }
                    .padding(Tokens.Spacing.codeBlockPadding)
            }
            .background(Tokens.Colors.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: Tokens.Spacing.codeBlockRadius))
            .markdownMargin(top: 0, bottom: Tokens.Spacing.blockSpacing)
        }
        .listItem { configuration in
            configuration.label
                .markdownMargin(top: .em(0.25))
        }
        .taskListMarker { configuration in
            Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
                .symbolRenderingMode(.hierarchical)
                .imageScale(.small)
                .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
        }
        .table { configuration in
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .markdownTableBorderStyle(.init(color: Tokens.Colors.separator))
                .markdownMargin(top: 0, bottom: Tokens.Spacing.blockSpacing)
        }
        .tableCell { configuration in
            configuration.label
                .markdownTextStyle {
                    if configuration.row == 0 {
                        FontWeight(.medium)
                    }
                    BackgroundColor(nil)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, Tokens.Spacing.tableCellPaddingV)
                .padding(.horizontal, Tokens.Spacing.tableCellPaddingH)
                .relativeLineSpacing(.em(0.25))
        }
        .thematicBreak {
            Divider()
                .overlay(Tokens.Colors.separator)
                .markdownMargin(top: Tokens.Spacing.headingTopSpacing, bottom: Tokens.Spacing.headingTopSpacing)
        }
}
