//
//  HiRouter.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2021/12/30.
//

import Foundation

open class RouteManager {
    //MARK: - typealias
    
    //MARK: - storage
    public static let `default`: RouteManager = .init()
    public var listenUnfoundRouter: ((_ app: String, _ module: String, _ method: String) -> Void)?
    private var entity: Entity = .init()
    //MARK: - lazy
    
    //MARK: - calculate
    
    //MARK: - init
    
    private init() {
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - deinit
    
    //MARK: - override
    
    
    //MARK: - public function
    
    /// 注册路由.
    /// - Parameters:
    ///   - app: app scheme.
    ///   - router: Router.
    @discardableResult
    open func register(app: String, router: Router) -> Bool {
        assert(Thread.isMainThread, "需要在主线程中")
        if !entity.apps.contains(app) {
            entity.apps.append(app)
        }
        let key = fetchModuleKey(app: app, module: router.module)
        var routers = entity.modules[key] ?? []
        let type = "\(type(of: router))"
        guard !entity.registered.contains(type) else {
            HiPrint(type, "已注册, 请勿重复注册!", level: .ERROR)
            return false
        }
        entity.registered.append(type)
        routers.append(router)
        entity.modules[key] = routers
        return true
    }
    
    /// 注销模块所有路由.
    /// - Parameters:
    ///   - app: app scheme.
    ///   - module: 模块名, host.
    @discardableResult
    open func destroy(app: String, module: String) -> Bool{
        assert(Thread.isMainThread, "需要在主线程中")
        entity.modules[fetchModuleKey(app: app, module: module)] = nil
        return true
    }
    
    /// 添加监听.
    /// - Parameter observer: RouterObserver
    open func add(observer: RouterObserver) {
        assert(Thread.isMainThread, "需要在主线程中")
        var observers = entity.subscribers[observer.module] ?? NSHashTable.init(options: .weakMemory)
        observers.add(observer)
        entity.subscribers[observer.module] = observers
    }
    
    /// 删除监听.
    /// - Parameter observer: RouterObserver
    open func remove(observer: RouterObserver) {
        assert(Thread.isMainThread, "需要在主线程中")
        entity.subscribers[observer.module]?.remove(observer)
    }
    
    /// 能否打开URL.
    /// - Parameter url: URL.
    /// - Returns: result.
    open func can(open url: URL) -> Bool {
        guard let app = url.scheme, !app.isEmpty else {
            return false
        }
        guard let module = url.host, !module.isEmpty else {
            return false
        }
        let method = url.path
        guard !method.isEmpty else {
            return false
        }
        return can(open: app, module: module, method: method)
    }
    
    /// 能否打开某功能.
    /// - Parameters:
    ///   - app: app.
    ///   - module: module.
    ///   - method: method.
    /// - Returns: result.
    open func can(open app: String, module: String, method: String) -> Bool {
        assert(Thread.isMainThread, "需要在主线程中")
        
        let cacheKey = fetchCacheKey(app: app, module: module, method: method)
        if entity.cacheModule.object(forKey: cacheKey) != nil {
            return true
        }
        guard let routers = fetchRouter(app: app, module: module) else {
            return false
        }
        for router in routers {
            if router.supportMethods.contains(method) {
                entity.cacheModule.setObject(router, forKey: cacheKey)
                return true
            }
        }
        return false
    }
    
    /// open.
    /// - Parameters:
    ///   - url: url.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    open func open(_ url: URL, completion: ((Any?) -> Void)? = nil) -> Bool {
        let options = analysis(query: url.query?.removingPercentEncoding)
        return open(url, options: options, completion: completion)
    }
    
    /// open.
    /// - Parameters:
    ///   - url: url.
    ///   - options: options.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    open func open(_ url: URL, options: Any?, completion: ((Any?) -> Void)? = nil) -> Bool{
        guard let app = url.scheme, !app.isEmpty, entity.apps.contains(app) else {
            unfoundRouter("", module: "", method: "")
            completion?(RouterError.unfoundApp)
            return false
        }
        guard let module = url.host, !module.isEmpty else {
            unfoundRouter(app, module: "", method: "")
            completion?(RouterError.unfoundModule)
            return false
        }
        let method = url.path
        guard !method.isEmpty else {
            unfoundRouter(app, module: module, method: "")
            completion?(RouterError.unfoundMethod)
            return false
        }
        return open(app: app, module: module, method: method, port: url.port, options: options, completion: completion)
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
    open func open(app: String, module: String, method: String, port: Int?, options: Any?, completion: ((Any?) -> Void)? = nil) -> Bool {
        assert(Thread.isMainThread, "需要在主线程中")
        
        func unfound(error: Error) {
            unfoundRouter(app, module: module, method: method)
            completion?(error)
        }
        
        let cacheKey = fetchCacheKey(app: app, module: module, method: method)
        if let router = entity.cacheModule.object(forKey: cacheKey) as? Router {
            let status = router.router(self, open: method, port: port, options: options, completion: completion)
            if !status {
                unfound(error: RouterError.unfoundMethod)
            }
            return status
        }
        guard let routers = fetchRouter(app: app, module: module) else {
            unfound(error: RouterError.unfoundRouter)
            return false
        }
        for router in routers {
            if router.supportMethods.contains(method) {
                entity.cacheModule.setObject(router, forKey: cacheKey)
                let status = router.router(self, open: method, port: port, options: options, completion: completion)
                if !status {
                    unfound(error: RouterError.unfoundMethod)
                }
                return status
            }
        }
        unfound(error: RouterError.unfoundRouter)
        return false
    }
    
    /// invoke.
    /// - Parameters:
    ///   - url: url.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    open func invoke(_ url: URL, completion: ((Any?) -> Void)? = nil) -> Bool {
        let options = analysis(query: url.query)
        return invoke(url, options: options, completion: completion)
    }
    
    /// invoke.
    /// - Parameters:
    ///   - url: url.
    ///   - options: options.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    open func invoke(_ url: URL, options: Any?, completion: ((Any?) -> Void)? = nil) -> Bool{
        guard let module = url.host, !module.isEmpty else {
            completion?(RouterError.unfoundModule)
            return false
        }
        
        let method = url.path
        guard !method.isEmpty else {
            return false
        }
        
        return invoke(module: module, method: method, port: url.port, options: options, completion: completion)
    }
    
    /// invoke.
    /// - Parameters:
    ///   - module: module.
    ///   - method: method.
    ///   - options: options.
    ///   - completion: completion.
    /// - Returns: status.
    @discardableResult
    open func invoke(module: String, method: String, port: Int?, options: Any?, completion: ((Any?) -> Void)? = nil) -> Bool{
        assert(Thread.isMainThread, "需要在主线程中")
        guard let observers = entity.subscribers[module], observers.count > 0 else {
            completion?(RouterError.unfoundObserver)
            return false
        }
        for item in observers.objectEnumerator() {
            if let router = item as? RouterObserver {
               _ = router.router(self, invoke: method, port: port, options: options, completion: completion)
            }
        }
        return true
    }
        
    public func unfoundRouter(_ app: String, module: String, method: String) {
        listenUnfoundRouter?(app, module, method)
        NotificationCenter.default.post(name: RouterNotification.unfoundRouter.rawValue, object: nil, userInfo: ["app": app, "module": module, "method": method])
    }
    
    //MARK: - private function
    
    private func fetchCacheKey(app: String, module: String, method: String) -> NSString {
        return (app + "/" + module + "/" + method) as NSString
    }
    
    private func fetchModuleKey(app: String, module: String) -> String {
        return app + "/" + module
    }
    
    private func fetchRouter(app: String, module: String) -> [Router]? {
        return entity.modules[fetchModuleKey(app: app, module: module)]
    }
    
    private func analysis(query: String?) -> [String: String] {
        let dic = query?.components(separatedBy: "&").map({
            $0.components(separatedBy: "=")
        }).reduce(into: [String: String](), {
            if let key = $1[safe: 0], let value = $1[safe: 1] {
                $0[key] = value
            }
        })
        return dic ?? [: ]
    }
    
    
    //MARK: - define
    public struct RouterNotification: Equatable, Hashable, RawRepresentable {
        
        
        
        public typealias RawValue = Notification.Name
        public var rawValue: Notification.Name
        
        /// userInfo: {app: String, module: String, method: String}
        public static let unfoundRouter = RouterNotification.init(notification: "com.hi.router.unfound.router.notification")
        
        
        public init(notification: String) {
            self.rawValue = Notification.Name.init(rawValue: notification)
        }
        
        public init(rawValue: Notification.Name) {
            self.rawValue = rawValue
        }
    }
}
