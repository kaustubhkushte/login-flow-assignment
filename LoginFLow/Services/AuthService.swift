import Foundation

protocol AuthServiceProtocol {
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse
    func login(email: String, password: String) async throws -> AuthResponse
    func fetchCurrentUser() async throws -> AppUser
    func persistSession(_ authResponse: AuthResponse) throws
    func logout() throws
}

final class AuthService: AuthServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let tokenStore: TokenStore

    init(httpClient: HTTPClientProtocol, tokenStore: TokenStore) {
        self.httpClient = httpClient
        self.tokenStore = tokenStore
    }

    func signUp(name: String, email: String, password: String) async throws -> AuthResponse {
        let request = SignUpRequest(name: name, email: email, password: password)
        return try await httpClient.request(.signup, body: request)
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let request = LoginRequest(email: email, password: password)
        return try await httpClient.request(.login, body: request)
    }

    func fetchCurrentUser() async throws -> AppUser {
        let response: CurrentUserResponse = try await httpClient.request(.currentUser)
        return response.user
    }

    func persistSession(_ authResponse: AuthResponse) throws {
        try tokenStore.save(token: authResponse.token)
    }

    func logout() throws {
        try tokenStore.clear()
    }
}
