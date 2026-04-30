import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var rememberMe = true
    @Published var isLoading = false
    @Published var fieldErrors: [String: String] = [:]
    @Published var generalError: String?

    private let authService: AuthServiceProtocol
    private let sessionRouter: AppSessionRouter

    init(authService: AuthServiceProtocol, sessionRouter: AppSessionRouter) {
        self.authService = authService
        self.sessionRouter = sessionRouter
    }

    func login() async {
        fieldErrors = [:]
        generalError = nil

        guard validate() else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await authService.login(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            try authService.persistSession(response)
            sessionRouter.setAuthenticated(from: response)
        } catch let appError as AppError {
            generalError = appError.errorDescription
        } catch {
            generalError = "Unable to log in right now. Please try again."
        }
    }

    private func validate() -> Bool {
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors["email"] = "Email is required."
        } else if !email.contains("@") {
            fieldErrors["email"] = "Enter a valid email address."
        }

        if password.isEmpty {
            fieldErrors["password"] = "Password is required."
        } else if password.count < 6 {
            fieldErrors["password"] = "Password must be at least 6 characters."
        }

        return fieldErrors.isEmpty
    }
}
