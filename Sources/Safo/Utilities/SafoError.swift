import Foundation

enum SafoError: Error, Equatable {
    case fileNotFound(String)
    case notMarkdownFile(String)
    case permissionDenied(String)
    case emptyFile
    case fileDeleted
}
