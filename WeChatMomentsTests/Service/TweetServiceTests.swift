//
//  TweetModelTests.swift
//  WeChatMomentsTests
//

@testable import WeChatMoments
import XCTest

class TweetServiceTests: XCTestCase {
    private var tweetService: TweetService!

    override func setUp() {
        self.tweetService = TweetService()
    }

    override class func tearDown() {
    }

    func testRightURL() {
        let readyExpectation = expectation(description: "ready")

        self.tweetService.getTweets(TestDataConfig.USER).done {
            tweets in
            if tweets?.count == 0 {
                XCTAssertTrue(false, "The tweets should be not nil")
            }
            readyExpectation.fulfill()
        }.catch { _ in
            XCTAssertThrowsError("request failed,error happen")
        }

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Error should not happen.")
        }
    }

    func testWrongURL() {
        let readyExpectation = expectation(description: "ready")
        tweetService.getTweets("jsmitn2").done { tweets in
            let numberOfTweets = tweets?.count ?? 0
            if numberOfTweets > 0 {
                XCTAssertTrue(false, "There should be not tweet")
            }
            readyExpectation.fulfill()
        }.catch { _ in
            XCTAssertThrowsError("request failed,error happen")
        }

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Error should not happen.")
        }
    }
}
