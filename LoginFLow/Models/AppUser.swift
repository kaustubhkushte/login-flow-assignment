import Foundation

struct AppUser: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
    }
}
