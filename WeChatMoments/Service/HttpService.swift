//
//  HttpService.swift
//  WeChatMoments
//


import Alamofire
import Foundation
import PromiseKit
import SwiftyJSON

protocol BaseService {
    func get(url: String) -> Promise<Data>
}

class HttpService: BaseService {
    internal func get(url: String) -> Promise<Data> {
        return Promise { resolve in
            AF.request(url).responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    resolve.resolve(data, nil)
                case .failure(let error):
                    resolve.reject(error)
                }
            })
        }
    }
}
