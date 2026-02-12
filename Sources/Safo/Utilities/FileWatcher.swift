import Foundation

final class FileWatcher {
    private let url: URL
    private let onChange: () -> Void
    private var source: DispatchSourceFileSystemObject?
    private var fileDescriptor: Int32 = -1
    private var debounceWorkItem: DispatchWorkItem?

    private static let debounceInterval: TimeInterval = 0.1

    init(url: URL, onChange: @escaping () -> Void) {
        self.url = url
        self.onChange = onChange
        startWatching()
    }

    deinit {
        stop()
    }

    func stop() {
        debounceWorkItem?.cancel()
        debounceWorkItem = nil
        source?.cancel()
        source = nil
    }

    // MARK: - Private

    private func startWatching() {
        let fd = open(url.path, O_EVTONLY)
        guard fd >= 0 else { return }
        fileDescriptor = fd

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: [.write, .rename, .delete],
            queue: .main
        )

        source.setEventHandler { [weak self] in
            guard let self else { return }
            let flags = source.data
            if flags.contains(.rename) || flags.contains(.delete) {
                self.handleRenameOrDelete()
            } else {
                self.debouncedOnChange()
            }
        }

        source.setCancelHandler { [fd] in
            close(fd)
        }

        source.resume()
        self.source = source
    }

    private func handleRenameOrDelete() {
        stop()

        // Editors like vim write by creating a new file and renaming.
        // Wait briefly then re-watch if the file reappears at the same path.
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.debounceInterval) { [weak self] in
            guard let self else { return }
            if FileManager.default.fileExists(atPath: self.url.path) {
                self.startWatching()
                self.onChange()
            } else {
                self.onChange()
            }
        }
    }

    private func debouncedOnChange() {
        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.onChange()
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.debounceInterval, execute: workItem)
    }
}
