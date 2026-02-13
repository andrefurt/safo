import SwiftUI

struct TitlebarView: View {
    @ObservedObject var viewModel: DocumentViewModel

    @State private var isCopied = false

    var body: some View {
        HStack(spacing: 0) {
            leadingContent
            Spacer()
            trailingContent
        }
        .frame(height: Tokens.Layout.titlebarHeight)
        .padding(.horizontal, Tokens.Layout.sidebarPadding)
        .padding(.leading, 68)
    }

    // MARK: - Leading

    @ViewBuilder
    private var leadingContent: some View {
        if let document = viewModel.document, let listing = viewModel.directoryListing {
            breadcrumb(document: document, listing: listing)
        } else {
            noFileTitlebar
        }
    }

    private var noFileTitlebar: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.toggleSidebar()
            } label: {
                Image(systemName: "sidebar.left")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Tokens.Colors.textSecondary)
            }
            .buttonStyle(.plain)

            HStack(spacing: 4) {
                Button {
                    viewModel.navigateToPrevious()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Tokens.Colors.textSecondary)
                }
                .buttonStyle(.plain)
                .disabled(!(viewModel.directoryListing?.hasPrevious ?? false))

                Button {
                    viewModel.navigateToNext()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Tokens.Colors.textSecondary)
                }
                .buttonStyle(.plain)
                .disabled(!(viewModel.directoryListing?.hasNext ?? false))
            }

            Text("Safo")
                .font(.system(size: Tokens.Typography.toolbarTitleSize, weight: .medium))
                .foregroundStyle(Tokens.Colors.textPrimary)
        }
    }

    private func breadcrumb(document: MarkdownDocument, listing: DirectoryListing) -> some View {
        HStack(spacing: 6) {
            Button {
                viewModel.toggleSidebar()
            } label: {
                Image(systemName: "sidebar.left")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Tokens.Colors.textSecondary)
            }
            .buttonStyle(.plain)

            breadcrumbSegments(document: document, listing: listing)
        }
    }

    private func breadcrumbSegments(document: MarkdownDocument, listing: DirectoryListing) -> some View {
        let relativePath = document.relativePath(to: listing.rootURL)
        let components = relativePath.split(separator: "/").map(String.init)

        return HStack(spacing: 4) {
            Text("Safo")
                .font(.system(size: Tokens.Typography.toolbarTitleSize, weight: .regular))
                .foregroundStyle(Tokens.Colors.textSecondary)

            ForEach(Array(components.enumerated()), id: \.offset) { index, component in
                Text("/")
                    .font(.system(size: Tokens.Typography.toolbarTitleSize))
                    .foregroundStyle(Tokens.Colors.textTertiary)

                let isLast = index == components.count - 1
                if isLast {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 10))
                            .foregroundStyle(Tokens.Colors.textSecondary)
                        Text(component)
                            .font(.system(size: Tokens.Typography.toolbarTitleSize, weight: .medium))
                            .foregroundStyle(Tokens.Colors.textPrimary)
                    }
                } else {
                    Text(component)
                        .font(.system(size: Tokens.Typography.toolbarTitleSize, weight: .regular))
                        .foregroundStyle(Tokens.Colors.textSecondary)
                }
            }
        }
    }

    // MARK: - Trailing

    private var trailingContent: some View {
        Button {
            viewModel.copyToClipboard()
            isCopied = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isCopied = false
            }
        } label: {
            Text(isCopied ? "Copied" : "Copy")
                .font(.system(size: Tokens.Typography.toolbarTitleSize, weight: .medium))
                .foregroundStyle(Tokens.Colors.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Tokens.Colors.separator, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(viewModel.document == nil)
        .opacity(viewModel.document == nil ? 0.4 : 1)
    }
}
