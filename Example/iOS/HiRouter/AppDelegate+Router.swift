//
//  AppDelegate+Router.swift
//  HiRouter_Example
//
//  Created by Yang Lanqing on 2022/1/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HiRouter


let app = "HiRouterExample"

extension AppDelegate {
    
    func routers() {
        registeredRouters()
        page404()
    }
    
    private func registeredRouters() {
        
        RouteManager.default.register(app: app, router: NativeRouter.init())
        RouteManager.default.register(app: app, router: WebRouter.init())
        RouteManager.default.register(app: app, router: FlutterRouter.init())
    }
    
    
    private func page404() {
        RouteManager.default.listenUnfoundRouter = {
            topNav?.pushViewController(PageMissingViewController.init($0, module: $1, method: $2), animated: true)
        }
    }
}
