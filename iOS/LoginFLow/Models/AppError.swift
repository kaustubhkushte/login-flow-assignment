import Foundation

enum AppError: LocalizedError, Equatable {
    case validation(message: String)
    case unauthorized(message: String)
    case server(message: String)
    case decoding
    case connectivity
    case timeout
    case unknown(message: String)

    var errorDescription: String? {
        switch self {
        case .validation(let message),
             .unauthorized(let message),
             .server(let message),
             .unknown(let message):
            return message
        case .decoding:
            return "We received an unexpected response. Please try again."
        case .connectivity:
            return "We could not reach the server. Check your internet connection."
        case .timeout:
            return "The request timed out. Please try again."
        }
    }
}
