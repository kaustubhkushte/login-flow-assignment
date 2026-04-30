import Combine
import Foundation

@MainActor
final class AppSessionRouter: ObservableObject {
    enum State: Equatable {
        case launching
        case unauthenticated
        case authenticated(AppUser)
    }

    @Published private(set) var state: State = .launching

    private let authService: AuthServiceProtocol
    private var hasBootstrapped = false

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    func bootstrap() async {
        guard !hasBootstrapped else { return }
        hasBootstrapped = true

        do {
            let user = try await authService.fetchCurrentUser()
            state = .authenticated(user)
        } catch {
            state = .unauthenticated
        }
    }

    func setAuthenticated(from authResponse: AuthResponse) {
        state = .authenticated(authResponse.user)
    }

    func refreshCurrentUser() async {
        do {
            let user = try await authService.fetchCurrentUser()
            state = .authenticated(user)
        } catch {
            state = .unauthenticated
        }
    }

    func logout() {
        do {
            try authService.logout()
        } catch {
            // Keep logout resilient even if clearing secure storage fails.
        }
        state = .unauthenticated
    }
}
