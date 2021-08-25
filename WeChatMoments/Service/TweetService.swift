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

    func getTweets(_ userName: String) -> Promise<[Tweet]> {
        let url = UrlConstant.tweetsUrl(name: userName)
        return httpService.get(url: url).map { results in
            guard let results = results else { return [] }
            let data = try? JSONSerialization.data(withJSONObject: results, options: [])
            let tweets: [Tweet] = try JSONDecoder().decode([Tweet].self, from: data!)
            return tweets
        }
    }
}
