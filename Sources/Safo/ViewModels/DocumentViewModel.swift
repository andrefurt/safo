import AppKit
import Foundation

@MainActor
final class DocumentViewModel: ObservableObject {
    @Published var document: MarkdownDocument?
    @Published var directoryListing: DirectoryListing?
    @Published private(set) var sidebarVisible = false
    @Published var error: SafoError?

    private var fileWatcher: FileWatcher?

    // MARK: - Navigation

    func open(url: URL) {
        error = nil
        fileWatcher?.stop()
        fileWatcher = nil

        do {
            let doc = try MarkdownDocument.load(from: url)

            if doc.content.isEmpty {
                error = .emptyFile
            }

            document = doc

            let directory = url.deletingLastPathComponent()
            directoryListing = DirectoryListing.scan(directory: directory, currentFile: url.standardizedFileURL)

            fileWatcher = FileWatcher(url: url) { [weak self] in
                self?.reloadCurrentFile()
            }
        } catch let safoError as SafoError {
            error = safoError
            document = nil
        } catch {
            self.error = .fileNotFound(url.path)
            document = nil
        }
    }

    func navigateToNext() {
        guard var listing = directoryListing, listing.hasNext else { return }
        listing.goToNext()
        directoryListing = listing
        if let file = listing.currentFile {
            open(url: file)
        }
    }

    func navigateToPrevious() {
        guard var listing = directoryListing, listing.hasPrevious else { return }
        listing.goToPrevious()
        directoryListing = listing
        if let file = listing.currentFile {
            open(url: file)
        }
    }

    func navigateTo(url: URL) {
        open(url: url)
    }

    // MARK: - Actions

    func copyToClipboard() {
        guard let content = document?.content else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: .string)
    }

    func toggleSidebar() {
        sidebarVisible.toggle()
    }

    // MARK: - Private

    private func reloadCurrentFile() {
        guard let currentURL = document?.url else { return }

        guard FileManager.default.fileExists(atPath: currentURL.path) else {
            error = .fileDeleted
            fileWatcher?.stop()
            fileWatcher = nil
            return
        }

        do {
            let doc = try MarkdownDocument.load(from: currentURL)
            document = doc
            error = doc.content.isEmpty ? .emptyFile : nil
        } catch {
            // File may be mid-write; ignore transient errors during reload
        }
    }
}
