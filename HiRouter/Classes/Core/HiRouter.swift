//
//  HiRouter.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2022/6/21.
//

import Foundation

@objcMembers
public class HiRouter: NSObject {
    
    class var manager: RouteManager {
        RouteManager.default
    }
}

public extension HiRouter {
    /// 注册路由.
    /// - Parameters:
    ///   - app: app scheme.
    ///   - router: Router.
    @discardableResult
    class func register(app: String, router: Router) -> Bool {
        return manager.register(app: app, router: router)
    }
    
    /// 注销模块所有路由.
    /// - Parameters:
    ///   - app: app scheme.
    ///   - module: 模块名, host.
    @discardableResult
    class func destroy(app: String, module: String) -> Bool{
        return manager.destroy(app: app, module: module)
    }
    
    /// 添加监听.
    /// - Parameter observer: RouterObserver
    class func add(observer: RouterObserver) {
        manager.add(observer: observer)
    }
    
    /// 删除监听.
    /// - Parameter observer: RouterObserver
    class func remove(observer: RouterObserver) {
        manager.remove(observer: observer)
    }
    
    /// 能否打开URL.
    /// - Parameter url: URL.
    /// - Returns: result.
    class func can(open url: URL) -> Bool {
        return manager.can(open: url)
    }
    
    /// 能否打开某功能.
    /// - Parameters:
    ///   - app: app.
    ///   - module: module.
    ///   - method: method.
    /// - Returns: result.
    class func can(open app: String, module: String, method: String) -> Bool {
        return manager.can(open: app, module: module, method: method)
    }
    
    /// open.
    /// - Parameters:
    ///   - url: url.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    class func open(_ url: URL, completion: ((Any?) -> Void)? = nil) -> Bool {
        return manager.open(url, completion: completion)
    }
    
    /// open.
    /// - Parameters:
    ///   - url: url.
    ///   - options: options.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    class func open(_ url: URL, options: Any?, completion: ((Any?) -> Void)? = nil) -> Bool{
        return manager.open(url, options: options, completion: completion)
    }
    
    /// open.
    /// - Parameters:
    ///   - app: app.
    ///   - module: module.
    ///   - method: method.
    ///   - options: options.
    ///   - completion: completion.
    /// - Returns: status
    @discardableResult
    class func open(app: String, module: String, method: String, port: Int?, options: Any?, completion: ((Any?) -> Void)? = nil) -> Bool {
        return manager.open(app: app, module: module, method: method, port: port, options: options, completion: completion)
    }
    
    /// invoke.
    /// - Parameters:
    ///   - url: url.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    class func invoke(_ url: URL, completion: ((Any?) -> Void)? = nil) -> Bool {
        manager.invoke(url, completion: completion)
    }
    
    /// invoke.
    /// - Parameters:
    ///   - url: url.
    ///   - options: options.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    class func invoke(_ url: URL, options: Any?, completion: ((Any?) -> Void)? = nil) -> Bool{
       return manager.invoke(url, options: options, completion: completion)
    }
    
    /// invoke.
    /// - Parameters:
    ///   - module: module.
    ///   - method: method.
    ///   - options: options.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    class func invoke(module: String, method: String, port: Int?, options: Any?, completion: ((Any?) -> Void)? = nil) -> Bool{
        return manager.invoke(module: module, method: method, port: port, options: options, completion: completion)
    }
        
    class func unfoundRouter(_ app: String, module: String, method: String) {
        manager.unfoundRouter(app, module: module, method: method)
    }
}
