//
//  Service.swift
//  WeChatMomentsTests
//


import Foundation
import OHHTTPStubs
import SwiftyJSON

@testable import WeChatMoments

struct HttpServiceMock {
    private static func response(json: Any, statusCode: Int32) -> HTTPStubsResponse {
        return HTTPStubsResponse(jsonObject: json, statusCode: statusCode, headers: ["Content-Type": "application/json"])
    }

    private static func isHost(_ host: String) -> HTTPStubsTestBlock {
        return { req in
            guard let url = req.url else {
                return false
            }
            return url.absoluteString.contains(host)
        }
    }

    static func fakeHost() {
        stub(condition: HttpServiceMock.isHost(TestDataConfig.URL_HOST)) { _ in
            HttpServiceMock.response(json: TestDataConfig.JSON_HOST, statusCode: 200)
        }
    }

    static func fakeUserProfile() {
        stub(condition: HttpServiceMock.isHost(TestDataConfig.URL_USER)) { req in
            guard let url = req.url else {
                return HttpServiceMock.response(json: TestDataConfig.NOT_FOUND, statusCode: 404)
            }

            if url.absoluteString.contains(TestDataConfig.USER) {
                return HttpServiceMock.response(json: TestDataConfig.JSON_USER, statusCode: 200)
            }

            return HttpServiceMock.response(json: TestDataConfig.BAD_REQUEST, statusCode: 400)
        }
    }

    static func fakeTweets() {
        stub(condition: HttpServiceMock.isHost("tweets")) { req in
            guard let url = req.url else {
                return HttpServiceMock.response(json: TestDataConfig.NOT_FOUND, statusCode: 404)
            }

            if url.absoluteString.contains(TestDataConfig.USER) {
                return HttpServiceMock.response(json: TestDataConfig.JSON_TWEETS, statusCode: 200)
            }

            return HttpServiceMock.response(json: TestDataConfig.BAD_REQUEST, statusCode: 400)
        }
    }
}
