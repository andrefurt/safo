import Foundation

struct MarkdownDocument: Identifiable, Equatable {
    let id: URL
    let url: URL
    var content: String
    var lastModified: Date

    var fileName: String {
        url.lastPathComponent
    }

    func relativePath(to rootURL: URL) -> String {
        let filePath = url.path
        let rootPath = rootURL.path
        if filePath.hasPrefix(rootPath) {
            let relative = String(filePath.dropFirst(rootPath.count))
            return relative.hasPrefix("/") ? String(relative.dropFirst()) : relative
        }
        return fileName
    }

    static func load(from url: URL) throws -> MarkdownDocument {
        let fileURL = url.standardizedFileURL

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw SafoError.fileNotFound(fileURL.path)
        }

        let ext = fileURL.pathExtension.lowercased()
        guard ext == "md" || ext == "markdown" else {
            throw SafoError.notMarkdownFile(fileURL.path)
        }

        let content: String
        do {
            content = try String(contentsOf: fileURL, encoding: .utf8)
        } catch let error as NSError where error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoPermissionError {
            throw SafoError.permissionDenied(fileURL.path)
        }

        let lastModified = (try? FileManager.default.attributesOfItem(atPath: fileURL.path))?[.modificationDate] as? Date ?? Date()

        return MarkdownDocument(
            id: fileURL,
            url: fileURL,
            content: content,
            lastModified: lastModified
        )
    }
}
