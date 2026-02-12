import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: DocumentViewModel

    var body: some View {
        Group {
            if let error = viewModel.error, viewModel.document == nil || error == .fileDeleted {
                ErrorStateView(error: error)
            } else if let document = viewModel.document {
                MarkdownContentView(content: document.content)
            } else {
                EmptyStateView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Tokens.Colors.background)
    }
}

// MARK: - Error state

private struct ErrorStateView: View {
    let error: SafoError

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: Tokens.Typography.bodySize, weight: .medium))
                .foregroundStyle(Tokens.Colors.textSecondary)
            if let detail {
                Text(detail)
                    .font(.system(size: Tokens.Typography.codeSize))
                    .foregroundStyle(Tokens.Colors.textTertiary)
            }
        }
    }

    private var title: String {
        switch error {
        case .fileNotFound:
            return "File not found"
        case .notMarkdownFile:
            return "Safo only opens markdown files"
        case .permissionDenied:
            return "Cannot read file: permission denied"
        case .emptyFile:
            return "Empty file"
        case .fileDeleted:
            return "File was deleted"
        }
    }

    private var detail: String? {
        switch error {
        case .fileNotFound(let path):
            return path
        case .notMarkdownFile(let path):
            return path
        case .permissionDenied(let path):
            return path
        case .emptyFile, .fileDeleted:
            return nil
        }
    }
}

// MARK: - Empty state (no file opened)

private struct EmptyStateView: View {
    var body: some View {
        Text("Open a markdown file to get started")
            .font(.system(size: Tokens.Typography.bodySize))
            .foregroundStyle(Tokens.Colors.textTertiary)
    }
}
