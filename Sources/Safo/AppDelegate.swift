import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false

        DispatchQueue.main.async {
            self.positionWindow()
        }
    }

    private func positionWindow() {
        guard let screen = NSScreen.main else { return }
        guard let window = NSApplication.shared.windows.first else { return }

        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.styleMask.insert(.fullSizeContentView)
        window.toolbar = nil

        let screenFrame = screen.visibleFrame
        let width = screenFrame.width * Tokens.Layout.windowWidthRatio

        let frame = NSRect(
            x: screenFrame.maxX - width,
            y: screenFrame.minY,
            width: width,
            height: screenFrame.height
        )

        window.setFrame(frame, display: true, animate: false)
    }
}
