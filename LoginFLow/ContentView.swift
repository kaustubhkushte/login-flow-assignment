import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var sessionRouter: AppSessionRouter

    var body: some View {
        ZStack {
            AuthGradientBackground()
                .ignoresSafeArea()

            switch sessionRouter.state {
            case .launching:
                ProgressView("Checking session...")
                    .tint(.white)
                    .foregroundStyle(.white)
            case .unauthenticated:
                AuthFlowView()
            case .authenticated(let user):
                ProfileView(user: user)
            }
        }
        .task {
            await sessionRouter.bootstrap()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppContainer.preview)
        .environmentObject(AppContainer.preview.sessionRouter)
}
