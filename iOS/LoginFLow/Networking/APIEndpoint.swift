import Alamofire
import Foundation

struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    let requiresAuthorization: Bool

    static let signup = APIEndpoint(path: "auth/signup", method: .post, requiresAuthorization: false)
    static let login = APIEndpoint(path: "auth/login", method: .post, requiresAuthorization: false)
    static let currentUser = APIEndpoint(path: "auth/me", method: .get, requiresAuthorization: true)
}
