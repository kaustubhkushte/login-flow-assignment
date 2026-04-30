import SwiftUI

@main
struct LoginFLowApp: App {
    @StateObject private var container = AppContainer.live()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container)
                .environmentObject(container.sessionRouter)
        }
    }
}
