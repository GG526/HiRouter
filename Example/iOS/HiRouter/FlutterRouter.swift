//
//  FlutterRouter.swift
//  HiRouter_Example
//
//  Created by Yang Lanqing on 2022/1/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HiRouter

class FlutterRouter: Router {
    var module: String {
        "flutter"
    }
    
    var supportMethods: [String] {
        return [
            Method.openFlutter.rawValue,
            Method.openNative.rawValue,
        ]
    }
    
    func router(_ router: RouteManager, open method: String, port: Int?, options: [String : Any]?, completion: ((Any?) -> Void)?) -> Bool {
        switch method {
            case Method.openFlutter.rawValue:
                return true
            case Method.openNative.rawValue:
                topNav?.pushViewController(NativeController.init(), animated: true)
                return true
            default:
                break
        }
        
        return false
    }
    
    enum Method: String {
        case openFlutter = "/open"
        case openNative = "/open/native"
    }
    
    
}
