//
//  NativeRouter.swift
//  HiRouter_Example
//
//  Created by Yang Lanqing on 2022/1/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HiRouter

class NativeRouter: Router {
    var module: String {
        "native"
    }
    
    var supportMethods: [String] {
        return [
            Method.openWeb.rawValue,
            Method.openNative.rawValue,
            Method.openFlutter.rawValue,
        ]
    }
    
    func router(_ router: RouteManager, open method: String, port: Int?, options: [String : Any]?, completion: ((Any?) -> Void)?) -> Bool {
        switch method {
            case Method.openWeb.rawValue:
                let url = options?["url"] as? String
                topNav?.pushViewController(WebController.init(url: url ?? ""), animated: true)
                return true
            case Method.openNative.rawValue:
                topNav?.pushViewController(NativeController.init(), animated: true)
                return true
            case Method.openFlutter.rawValue:
                topNav?.pushViewController(HiFlutterViewController.init(withEntrypoint: ""), animated: true)
                return true
            default:
                break
        }
        return false
    }
    
    
    
    enum Method: String {
        case openFlutter = "/open/flutter", openWeb = "/open/web", openNative = "/open/native"
    }
    
}

