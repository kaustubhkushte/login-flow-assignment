import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct SignUpRequest: Encodable {
    let name: String
    let email: String
    let password: String
}

struct AuthResponse: Decodable {
    let token: String
    let user: AppUser
}

struct CurrentUserResponse: Decodable {
    let user: AppUser
}

struct FieldErrorResponse: Decodable {
    let field: String
    let message: String
}

struct BackendErrorResponse: Decodable {
    let message: String
    let errors: [FieldErrorResponse]?
}
