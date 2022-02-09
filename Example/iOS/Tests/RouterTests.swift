//
//  RouterTests.swift
//  HiRouter_Tests
//
//  Created by Yang Lanqing on 2022/1/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import HiRouter

class RouterTests: QuickSpec {
    
    override func spec() {
        
        describe("Router") { [weak self] in
            guard let `self` = self else {
                return
            }
            it("注册") {
                self.register()
            }
            it("注册监听") {
                self.observer()
            }
            it("can open") {
                if let url = URL.init(string: "HiRouter: //Login/post/login") {
                    let status = HiRouter.default.can(open: url)
                    expect(status) == true
                }
            }
            
            it("不能打开某功能") {
                if let url = URL.init(string: "HiRouter: //Login/post/login2") {
                    let status = HiRouter.default.can(open: url)
                    expect(status) == false
                }
            }

            it("调用某功能") {
                if let url = URL.init(string: "HiRouter: //IAP/post/recharge") {
                    let status = HiRouter.default.open(url) { result in
                        print(result ?? "空结果")
                    }
                    expect(status) == true
                }
            }

            it("调用未实现功能") {
                if let url = URL.init(string: "HiRouter: //IAP/post/recharge2") {
                    let status = HiRouter.default.open(url) { result in
                        print(result ?? "空结果")
                    }
                    expect(status) == false
                }
            }
        }
    }
    
    func register() {
        HiRouter.default.register(app: "HiRouter", router: Router1.init())
        HiRouter.default.register(app: "HiRouter", router: Router2.init())
    }
    
    func observer() {
        HiRouter.default.listenUnfoundRouter = {
            print("listenUnfoundRouter", $0, $1, $2)
        }

        NotificationCenter.default.addObserver(forName: HiRouter.RouterNotification.unfoundRouter, object: self, queue: nil) { notification in
            guard let userInfo = notification.userInfo else {
                return
            }
            print("NotificationCenter", userInfo["app"] ?? "", userInfo["module"] ?? "", userInfo["method"] ?? "")
        }
    }
    
}


class Router1: Router {
    var module: String {
        "Login"
    }
    
    var supportMethods: [String] {
        return [
            "/get/loginState",
            "/post/login"
        ]
    }
    
    func router(_ router: HiRouter, open method: String, port: Int?, options: [String : Any]?, completion: ((Any?) -> Void)?) -> Bool {



        return false
    }
    
    
    
    
}

class Router2: Router {
    var module: String {
        "IAP"
    }
    
    var supportMethods: [String] {
        return [
            "/post/recharge"
        ]
    }
    
    func router(_ router: HiRouter, open method: String, port: Int?, options: [String : Any]?, completion: ((Any?) -> Void)?) -> Bool {


        return false
    }
}
