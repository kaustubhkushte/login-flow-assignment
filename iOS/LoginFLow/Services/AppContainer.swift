import Combine
import Foundation

@MainActor
final class AppContainer: ObservableObject {
    let tokenStore: TokenStore
    let httpClient: HTTPClientProtocol
    let authService: AuthServiceProtocol
    let sessionRouter: AppSessionRouter

    init(
        tokenStore: TokenStore,
        httpClient: HTTPClientProtocol,
        authService: AuthServiceProtocol,
        sessionRouter: AppSessionRouter
    ) {
        self.tokenStore = tokenStore
        self.httpClient = httpClient
        self.authService = authService
        self.sessionRouter = sessionRouter
    }

    static func live() -> AppContainer {
        let tokenStore = KeychainTokenStore()
        let httpClient = HTTPClient(tokenStore: tokenStore)
        let authService = AuthService(httpClient: httpClient, tokenStore: tokenStore)
        let sessionRouter = AppSessionRouter(authService: authService)
        return AppContainer(
            tokenStore: tokenStore,
            httpClient: httpClient,
            authService: authService,
            sessionRouter: sessionRouter
        )
    }

    static let preview: AppContainer = {
        let tokenStore = InMemoryTokenStore()
        let httpClient = MockHTTPClient()
        let authService = AuthService(httpClient: httpClient, tokenStore: tokenStore)
        let sessionRouter = AppSessionRouter(authService: authService)
        return AppContainer(
            tokenStore: tokenStore,
            httpClient: httpClient,
            authService: authService,
            sessionRouter: sessionRouter
        )
    }()
}

final class InMemoryTokenStore: TokenStore {
    private var token: String?

    func save(token: String) throws {
        self.token = token
    }

    func readToken() throws -> String? {
        token
    }

    func clear() throws {
        token = nil
    }
}

final class MockHTTPClient: HTTPClientProtocol {
    func request<Response>(_ endpoint: APIEndpoint) async throws -> Response where Response : Decodable {
        if endpoint.path == "/auth/me" {
            return CurrentUserResponse(
                user: AppUser(id: "preview-user", name: "Preview User", email: "preview@example.com")
            ) as! Response
        }
        throw AppError.unknown(message: "Preview client is not configured for this request.")
    }

    func request<Response, Body>(_ endpoint: APIEndpoint, body: Body) async throws -> Response where Response : Decodable, Body : Encodable {
        if endpoint.path == "/auth/login" || endpoint.path == "/auth/signup" {
            return AuthResponse(
                token: "preview-token",
                user: AppUser(id: "preview-user", name: "Preview User", email: "preview@example.com")
            ) as! Response
        }
        throw AppError.unknown(message: "Preview client is not configured for this request.")
    }
}
