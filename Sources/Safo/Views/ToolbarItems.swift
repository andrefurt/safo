import SwiftUI

struct ToolbarItems: ToolbarContent {
    @ObservedObject var viewModel: DocumentViewModel

    @State private var isCopied = false

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigation) {
            Button {
                viewModel.navigateToPrevious()
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(!(viewModel.directoryListing?.hasPrevious ?? false))
            .keyboardShortcut("[", modifiers: .command)

            Button {
                viewModel.navigateToNext()
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(!(viewModel.directoryListing?.hasNext ?? false))
            .keyboardShortcut("]", modifiers: .command)
        }

        ToolbarItem(placement: .principal) {
            if let document = viewModel.document {
                VStack(spacing: 1) {
                    Text(document.fileName)
                        .font(.system(size: Tokens.Typography.toolbarTitleSize, weight: .medium))
                        .foregroundStyle(Tokens.Colors.textPrimary)
                    if let listing = viewModel.directoryListing {
                        Text(document.relativePath(to: listing.rootURL))
                            .font(.system(size: Tokens.Typography.toolbarSubtitleSize))
                            .foregroundStyle(Tokens.Colors.textSecondary)
                    }
                }
            }
        }

        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                viewModel.copyToClipboard()
                isCopied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isCopied = false
                }
            } label: {
                Text(isCopied ? "Copied" : "Copy")
            }
            .disabled(viewModel.document == nil)
        }
    }
}
