import Foundation
import PromiseKit

class UserService {
    private var httpService: BaseService

    init() {
        self.httpService = HttpService()
    }

    func getUserProfile(_ name: String) -> Promise<User?> {
        let url = UrlConstant.userProfleUrl(name: name)
        return httpService.get(url: url).map { result in
            let json = result as? [String: Any] ?? [:]
            let data = try? JSONSerialization.data(withJSONObject: json, options: [])
            let user: User = try! JSONDecoder().decode(User.self, from: data!)
            return user
        }
    }
}

