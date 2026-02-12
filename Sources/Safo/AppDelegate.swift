import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.async {
            self.positionWindow()
        }
    }

    private func positionWindow() {
        guard let screen = NSScreen.main else { return }
        guard let window = NSApplication.shared.windows.first else { return }

        let screenFrame = screen.visibleFrame
        let width = screenFrame.width * 0.4

        let frame = NSRect(
            x: screenFrame.maxX - width,
            y: screenFrame.minY,
            width: width,
            height: screenFrame.height
        )

        window.setFrame(frame, display: true, animate: false)
    }
}
