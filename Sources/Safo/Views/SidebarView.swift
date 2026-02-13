import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: DocumentViewModel

    var body: some View {
        List {
            if let listing = viewModel.directoryListing {
                let grouped = groupedFiles(listing: listing)

                if !grouped.rootFiles.isEmpty {
                    ForEach(grouped.rootFiles, id: \.self) { url in
                        fileRow(url: url, listing: listing)
                    }
                }

                ForEach(grouped.folders, id: \.name) { folder in
                    Section(folder.name) {
                        ForEach(folder.files, id: \.self) { url in
                            fileRow(url: url, listing: listing)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func fileRow(url: URL, listing: DirectoryListing) -> some View {
        let isCurrent = url == listing.currentFile

        return Button {
            viewModel.navigateTo(url: url)
        } label: {
            Text(url.lastPathComponent)
                .font(.system(size: Tokens.Typography.sidebarSize))
                .foregroundStyle(isCurrent ? Tokens.Colors.accent : Tokens.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .listRowBackground(
            isCurrent ? Tokens.Colors.selectionBackground : Color.clear
        )
    }
}

// MARK: - File grouping

private extension SidebarView {
    struct FolderGroup: Equatable {
        let name: String
        let files: [URL]
    }

    struct GroupedFiles {
        let rootFiles: [URL]
        let folders: [FolderGroup]
    }

    func groupedFiles(listing: DirectoryListing) -> GroupedFiles {
        var rootFiles: [URL] = []
        var folderMap: [String: [URL]] = [:]

        let rootPath = listing.rootURL.path

        for file in listing.files {
            let filePath = file.path
            let relativePath: String
            if filePath.hasPrefix(rootPath) {
                let stripped = String(filePath.dropFirst(rootPath.count))
                relativePath = stripped.hasPrefix("/") ? String(stripped.dropFirst()) : stripped
            } else {
                relativePath = file.lastPathComponent
            }
            let components = relativePath.split(separator: "/")

            if components.count == 1 {
                rootFiles.append(file)
            } else {
                let folderName = String(components[0])
                folderMap[folderName, default: []].append(file)
            }
        }

        let folders = folderMap.keys.sorted().map { name in
            FolderGroup(name: name, files: folderMap[name] ?? [])
        }

        return GroupedFiles(rootFiles: rootFiles, folders: folders)
    }
}
