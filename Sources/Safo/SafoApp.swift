import SwiftUI

@main
struct SafoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = DocumentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .task {
                    openInitialFile()
                }
        }
    }

    private func openInitialFile() {
        // Check launch arguments for a file path (Phase 3 will add URL scheme handling)
        let args = CommandLine.arguments
        if args.count > 1 {
            let path = args[1]
            let url = URL(fileURLWithPath: path)
            viewModel.open(url: url)
        }
    }
}
