import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: DocumentViewModel

    var body: some View {
        ZStack(alignment: .topLeading) {
            detailContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, Tokens.Layout.titlebarHeight)

            TitlebarView(viewModel: viewModel)
                .zIndex(1)

            if viewModel.sidebarVisible {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.toggleSidebar()
                    }
                    .zIndex(2)

                floatingSidebar
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    .zIndex(3)
            }
        }
        .background(Tokens.Colors.background)
    }

    @ViewBuilder
    private var detailContent: some View {
        if let error = viewModel.error, viewModel.document == nil || error == .fileDeleted {
            ErrorStateView(error: error)
        } else if let document = viewModel.document {
            MarkdownContentView(content: document.content)
        } else {
            EmptyStateView()
        }
    }

    private var floatingSidebar: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    viewModel.toggleSidebar()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Tokens.Colors.textSecondary)
                }
                .buttonStyle(.plain)
                .padding(12)
            }

            SidebarView(viewModel: viewModel)
        }
        .frame(width: Tokens.Layout.sidebarWidth)
        .background(Tokens.Colors.sidebarBackground)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.Layout.sidebarCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Layout.sidebarCornerRadius)
                .stroke(Tokens.Colors.separator, lineWidth: Tokens.Layout.sidebarBorderWidth)
        )
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
        .padding(Tokens.Layout.sidebarPadding)
    }
}

// MARK: - Error state

private struct ErrorStateView: View {
    let error: SafoError

    var body: some View {
        VStack(spacing: Tokens.Spacing.errorStateGap) {
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
