//
//  UserServiceTests.swift
//  WeChatMomentsTests
//

@testable import WeChatMoments
import XCTest

class UserServiceTests: XCTestCase {
    private var userService: UserService!

    override func setUp() {
        self.userService = UserService()
    }

    override class func tearDown() {
    }

    func testRightURL() {
        let readyExpectation = expectation(description: "ready")

        self.userService.getUserProfile(TestDataConfig.USER).done {
            user in
            if let user = user,
               let username = user["username"] as? String {
                XCTAssertEqual(TestDataConfig.USER, username, "User should be jsmith.(\(username))")
            } else {
                XCTAssertTrue(false, "User should be jsmith.")
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
        userService.getUserProfile("jsmitn2").done {
            user in
            XCTAssertNil(user, "User should be nil.")
            readyExpectation.fulfill()
        }.catch { _ in
            XCTAssertThrowsError("request failed,error happen")
        }

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Error should not happen.")
        }
    }
}
