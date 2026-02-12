import AppKit
import Foundation
import SwiftUI

@MainActor
final class DocumentViewModel: ObservableObject {
    @Published var document: MarkdownDocument?
    @Published var directoryListing: DirectoryListing?
    @Published var sidebarVisible = false
    @Published var error: SafoError?

    private var fileWatcher: FileWatcher?

    // MARK: - Navigation

    func open(url: URL) {
        loadFile(url: url, rescanDirectory: true)
    }

    func navigateToNext() {
        guard var listing = directoryListing, listing.hasNext else { return }
        listing.goToNext()
        directoryListing = listing
        if let file = listing.currentFile {
            loadFile(url: file, rescanDirectory: false)
        }
    }

    func navigateToPrevious() {
        guard var listing = directoryListing, listing.hasPrevious else { return }
        listing.goToPrevious()
        directoryListing = listing
        if let file = listing.currentFile {
            loadFile(url: file, rescanDirectory: false)
        }
    }

    func navigateTo(url: URL) {
        guard var listing = directoryListing else {
            open(url: url)
            return
        }
        listing.goTo(url: url)
        directoryListing = listing
        loadFile(url: url, rescanDirectory: false)
    }

    // MARK: - Actions

    func copyToClipboard() {
        guard let content = document?.content else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: .string)
    }

    func toggleSidebar() {
        withAnimation(Tokens.Animation.sidebar) {
            sidebarVisible.toggle()
        }
    }

    // MARK: - Private

    private func loadFile(url: URL, rescanDirectory: Bool) {
        error = nil
        fileWatcher?.stop()
        fileWatcher = nil

        do {
            let doc = try MarkdownDocument.load(from: url)

            if doc.content.isEmpty {
                error = .emptyFile
            }

            document = doc

            if rescanDirectory {
                let directory = url.deletingLastPathComponent()
                directoryListing = DirectoryListing.scan(directory: directory, currentFile: url.standardizedFileURL)
            }

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
