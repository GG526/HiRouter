//
//  WebRouter.swift
//  HiRouter_Example
//
//  Created by Yang Lanqing on 2022/1/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HiRouter

class WebRouter: Router {
    var module: String {
        "web"
    }
    
    var supportMethods: [String] {
        return [
            Method.openWeb.rawValue,
            Method.syc.rawValue,
            Method.asyc.rawValue,
        ]
    }
    
    func router(_ router: RouteManager, open method: String, port: Int?, options: [String : Any]?, completion: ((Any?) -> Void)?) -> Bool {
        switch method {
            case Method.openWeb.rawValue:
                let dic = serialization(options: options)
                guard !dic.isEmpty else {
                    return false
                }
                topNav?.pushViewController(WebController.init(url: dic["url"] ?? ""), animated: true)
                return true
            case Method.syc.rawValue:
                let dic = serialization(options: options)
                let alert = UIAlertController.init(title: "NativeAlert", message: "\(dic)", preferredStyle: .alert)
                alert.addAction(.init(title: "确定", style: .default, handler: nil))
                alert.addAction(.init(title: "取消", style: .cancel, handler: nil))
                topVC?.present(alert, animated: true, completion: nil)
                return true
            case Method.asyc.rawValue:
                let dic = serialization(options: options)
                let alert = UIAlertController.init(title: "NativeAlert", message: "\(dic)", preferredStyle: .alert)
                alert.addAction(.init(title: "确定", style: .default, handler: { [weak self] _ in
                    guard let `self` = self else {
                        return
                    }
                    let json = self.deserialization(options: [
                        "code": 0,
                        "data": "",
                        "message": "成功"
                    ])
                    completion?(json)
                }))
                topVC?.present(alert, animated: true, completion: nil)
                return true
            default:
                break
        }
        
        return false
    }
    
    private func serialization(options: [String: Any]?) -> [String: String] {
        guard let queryString = options?["query"] as? String else {
            return [: ]
        }
        
        guard let data = queryString.removingPercentEncoding?.data(using: .utf8) else {
            return [: ]
        }
        
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
            return [: ]
        }
        
        return dic
    }
    
    private func deserialization(options: [String: Any]) -> String {
        guard !options.isEmpty else {
            return ""
        }
        guard let data = try? JSONSerialization.data(withJSONObject: options, options: []) else {
            return ""
        }
        
        guard let jsonString = String.init(data: data, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }
    
    enum Method: String {
        case openWeb = "/open/web"
        case syc = "/synchronous"
        case asyc = "/asynchronous"
    }
}
