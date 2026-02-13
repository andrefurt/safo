import SwiftUI

@main
struct SafoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = DocumentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .onOpenURL { url in
                    handleOpenURL(url)
                }
                .task {
                    openFromLaunchArguments()
                }
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandGroup(after: .sidebar) {
                Button("Toggle Sidebar") {
                    viewModel.toggleSidebar()
                }
                .keyboardShortcut("s", modifiers: [.command, .shift])
            }
        }
    }

    private func handleOpenURL(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let path = components.queryItems?.first(where: { $0.name == "path" })?.value
        else { return }

        let fileURL = URL(fileURLWithPath: path)
        viewModel.open(url: fileURL)
    }

    private func openFromLaunchArguments() {
        let args = CommandLine.arguments
        guard args.count > 1 else { return }

        let path = args[1]
        let url = URL(fileURLWithPath: path)
        viewModel.open(url: url)
    }
}
