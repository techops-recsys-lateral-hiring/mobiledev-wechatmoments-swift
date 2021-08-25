struct Comment: Decodable {
    let content: String?
    let sender: User?
}

struct User: Decodable {
    let username: String?
    let nick: String?
    let avatar: String?
    let profile: String?
}

struct Tweet: Decodable {
    let sender: User?
    let images: [[String: String]]?
    let comments:[Comment]?
    let content: String?
}
