import Foundation

struct DirectoryListing: Equatable {
    let rootURL: URL
    var files: [URL]
    var currentIndex: Int

    var currentFile: URL? {
        guard files.indices.contains(currentIndex) else { return nil }
        return files[currentIndex]
    }

    var hasPrevious: Bool {
        currentIndex > 0
    }

    var hasNext: Bool {
        currentIndex < files.count - 1
    }

    mutating func goToNext() {
        guard hasNext else { return }
        currentIndex += 1
    }

    mutating func goToPrevious() {
        guard hasPrevious else { return }
        currentIndex -= 1
    }

    mutating func goTo(url: URL) {
        guard let index = files.firstIndex(of: url) else { return }
        currentIndex = index
    }

    static func scan(directory: URL, currentFile: URL? = nil) -> DirectoryListing {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return DirectoryListing(rootURL: directory, files: [], currentIndex: 0)
        }

        var files: [URL] = []
        for case let fileURL as URL in enumerator {
            if fileURL.pathExtension.lowercased() == "md" {
                files.append(fileURL)
            }
        }

        files.sort { $0.path < $1.path }

        let index: Int
        if let currentFile, let found = files.firstIndex(of: currentFile) {
            index = found
        } else {
            index = 0
        }

        return DirectoryListing(rootURL: directory, files: files, currentIndex: index)
    }
}
