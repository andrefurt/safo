import Foundation

@main
struct SafoCLI {
    static func main() {
        guard CommandLine.arguments.count > 1 else {
            printUsage()
            exit(1)
        }

        let rawPath = CommandLine.arguments[1]
        let absolutePath = resolveAbsolutePath(rawPath)

        guard FileManager.default.fileExists(atPath: absolutePath) else {
            printError("file not found: \(absolutePath)")
            exit(1)
        }

        let fileExtension = URL(fileURLWithPath: absolutePath).pathExtension.lowercased()
        guard fileExtension == "md" || fileExtension == "markdown" else {
            printError("not a markdown file: \(absolutePath)")
            exit(1)
        }

        guard let encodedPath = absolutePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            printError("could not encode path: \(absolutePath)")
            exit(1)
        }

        let urlString = "safo://open?path=\(encodedPath)"

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        process.arguments = [urlString]

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            printError("could not open Safo: \(error.localizedDescription)")
            exit(1)
        }
    }

    private static func resolveAbsolutePath(_ rawPath: String) -> String {
        let expanded: String

        if rawPath.hasPrefix("~") {
            expanded = NSString(string: rawPath).expandingTildeInPath
        } else if !rawPath.hasPrefix("/") {
            let cwd = FileManager.default.currentDirectoryPath
            expanded = URL(fileURLWithPath: cwd).appendingPathComponent(rawPath).path
        } else {
            expanded = rawPath
        }

        return URL(fileURLWithPath: expanded).standardized.path
    }

    private static func printUsage() {
        let message = """
Usage: safo <file.md>

Open a markdown file in Safo for preview.
"""
        FileHandle.standardError.write(Data(message.utf8))
        FileHandle.standardError.write(Data("\n".utf8))
    }

    private static func printError(_ message: String) {
        let output = "safo: \(message)\n"
        FileHandle.standardError.write(Data(output.utf8))
    }
}
