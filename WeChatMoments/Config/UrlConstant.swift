//
//  UrlConstant.swift
//  WeChatMoments
//


import UIKit

struct UrlConstant {
    private static let HOST = "http://localhost:2727"
    
    static func userProfleUrl(name: String) -> String {
        return "\(UrlConstant.HOST)/user/\(name)"
    }

    static func tweetsUrl(name: String) -> String {
        return "\(UrlConstant.HOST)/user/\(name)/tweets"
    }
}
