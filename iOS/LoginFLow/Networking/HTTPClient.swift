import Alamofire
import Foundation

protocol HTTPClientProtocol {
    func request<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response
    func request<Response: Decodable, Body: Encodable>(_ endpoint: APIEndpoint, body: Body) async throws -> Response
}

final class HTTPClient: HTTPClientProtocol {
    private let session: Session
    private let tokenStore: TokenStore
    private let decoder: JSONDecoder

    init(tokenStore: TokenStore) {
        self.session = Session(configuration: .af.default)
        self.tokenStore = tokenStore
        self.decoder = JSONDecoder()
    }

    func request<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response {
        try await execute(endpoint: endpoint, body: Optional<EmptyBody>.none)
    }

    func request<Response: Decodable, Body: Encodable>(_ endpoint: APIEndpoint, body: Body) async throws -> Response {
        try await execute(endpoint: endpoint, body: body)
    }

    private func execute<Response: Decodable, Body: Encodable>(
        endpoint: APIEndpoint,
        body: Body?
    ) async throws -> Response {
        let headers = try authorizationHeaders(for: endpoint)
        let url = AppEnvironment.baseURL.appendingPathComponent(endpoint.path)

        #if DEBUG
        print("[HTTP] \(endpoint.method.rawValue) \(url.absoluteString)")
        #endif

        let request: DataRequest
        if let body {
            request = session.request(
                url,
                method: endpoint.method,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: headers
            )
        } else {
            request = session.request(
                url,
                method: endpoint.method,
                headers: headers
            )
        }

        let response = await request
            .validate()
            .serializingData()
            .response

        #if DEBUG
        if let statusCode = response.response?.statusCode {
            print("[HTTP] Status: \(statusCode)")
        }
        #endif

        guard let data = response.data else {
            throw mapError(response.error, data: nil)
        }

        if let error = response.error {
            throw mapError(error, data: data)
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw AppError.decoding
        }
    }

    private func authorizationHeaders(for endpoint: APIEndpoint) throws -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        if endpoint.method != .get {
            headers.add(name: "Content-Type", value: "application/json")
        }
        if endpoint.requiresAuthorization {
            guard let token = try tokenStore.readToken() else {
                throw AppError.unauthorized(message: "Your session has expired. Please log in again.")
            }
            headers.add(name: "Authorization", value: "Bearer \(token)")
        }
        return headers
    }

    private func mapError(_ error: AFError?, data: Data?) -> AppError {
        if let afError = error {
            if afError.isSessionTaskError, let underlyingError = afError.underlyingError as? URLError {
                switch underlyingError.code {
                case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost, .cannotConnectToHost:
                    return .connectivity
                case .timedOut:
                    return .timeout
                default:
                    break
                }
            }

            if let statusCode = afError.responseCode {
                if statusCode == 401 {
                    if let data,
                       let backendError = try? decoder.decode(BackendErrorResponse.self, from: data) {
                        return .unauthorized(message: backendError.message)
                    }
                    return .unauthorized(message: "Your email or password is incorrect.")
                }

                if let data,
                   let backendError = try? decoder.decode(BackendErrorResponse.self, from: data) {
                    return .server(message: backendError.message)
                }

                return .server(message: "The server returned an error. Please try again.")
            }
        }

        if let data,
           let backendError = try? decoder.decode(BackendErrorResponse.self, from: data) {
            return .server(message: backendError.message)
        }

        return .unknown(message: "Something went wrong. Please try again.")
    }
}

private struct EmptyBody: Encodable {}
