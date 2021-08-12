//
//  HttpServiceTests.swift
//  WeChatMomentsTests
//


import OHHTTPStubs
@testable import WeChatMoments
import XCTest

class HttpServiceTests: XCTestCase {
    private var service: HttpService!
    
    override func setUp() {
        HttpServiceMock.fakeHost()
        service = HttpService()
    }
    
    override class func tearDown() {
        HTTPStubs.removeAllStubs()
    }
    
    func testGetSuccess() {
        let readyExpectation = expectation(description: "ready")
        
        service.get(url: TestDataConfig.URL_HOST).done { jsonString in
            XCTAssert(jsonString != nil, "Request should  success.")
            
            readyExpectation.fulfill()
        }.catch { _ in
            XCTAssertThrowsError("request failed,error happen")
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "Error should not happen.")
        }
    }
}
