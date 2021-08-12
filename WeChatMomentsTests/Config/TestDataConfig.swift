//
//  Config.swift
//  WeChatMomentsTests
//


import Foundation
import SwiftyJSON

struct TestDataConfig {
    static let USER = "jsmith"
    static let URL_HOST = "http://localhost:2727"
    static let URL_USER = "\(TestDataConfig.URL_HOST)/user"
    static let URL_TWEETS = "\(TestDataConfig.URL_HOST)/user/\(TestDataConfig.USER)/tweets"

    static let JSON_HOST = ["status": "ok"]
    static let BAD_REQUEST = ["staust": "bad request"]
    static let NOT_FOUND = ["staust": "not found"]

    static let JSON_USER = ["profile-image": "http://img2.findthebest.com/sites/default/files/688/media/images/Mingle_159902_i0.png", "avatar": "http://info.thoughtworks.com/rs/thoughtworks2/images/glyph_badge.png", "nick": "John Smith", "username": TestDataConfig.USER]

    static let JSON_TWEETS = [["content": "Good.", "sender": ["username": "outman", "nick": "Super hero", "avatar": "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRJm8UXZ0mYtjv1a48RKkFkdyd4kOWLJB0o_l7GuTS8-q8VF64w"]]]

    static let JSON_COMMENTS = [["content": "Good.", "sender": ["username": "outman", "nick": "Super hero", "avatar": "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRJm8UXZ0mYtjv1a48RKkFkdyd4kOWLJB0o_l7GuTS8-q8VF64w"]] as [String: Any]]
}
