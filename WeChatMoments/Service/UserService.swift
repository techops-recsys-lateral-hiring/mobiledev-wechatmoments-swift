//
//  UserService.swift
//  WeChatMoments
//


import Foundation
import PromiseKit

class UserService {
    private var httpService: BaseService

    init() {
        self.httpService = HttpService()
    }

    func getUserProfile(_ name: String) -> Promise<[String: Any]?> {
        let url = UrlConstant.userProfleUrl(name: name)
        return httpService.get(url: url).map { result -> [String: Any]? in
            return result as? [String: Any]
        }
    }
}
