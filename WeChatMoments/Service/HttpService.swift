//
//  HttpService.swift
//  WeChatMoments
//


import Alamofire
import Foundation
import PromiseKit
import SwiftyJSON

protocol BaseService {
    func get(url: String) -> Promise<Any?>
}

class HttpService: BaseService {
    internal func get(url: String) -> Promise<Any?> {
        return Promise { resolve in
            AF.request(url).responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    resolve.resolve(value, nil)
                case .failure(let error):
                    resolve.reject(error)
                }
            })
        }
    }
}
