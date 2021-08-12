//
//  TweetService.swift
//  WeChatMoments
//


import Foundation
import PromiseKit

class TweetService {
    private var httpService: BaseService

    init() {
        self.httpService = HttpService()
    }

    func getTweets(_ userName: String) -> Promise<[[String: Any]]?> {
        let url = UrlConstant.tweetsUrl(name: userName)
        return httpService.get(url: url).map { result -> [[String: Any]]? in
            return result as? [[String: Any]]
        }
    }
}
