//
//  Entity.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2021/12/30.
//

import Foundation

class Entity {
    
    /// scheme
    var apps: [String]
    
    /// host
    var modules: [String: [Router]]
    
    /// 方法缓存 app+module+method -> router
    var cacheModule: NSMapTable<NSString, AnyObject>
    
    /// 已注册的类型(备注: 防止重复注册路由)
    var registered: [String]
    
    /// 订阅者
    var subscribers: [String: NSHashTable<AnyObject>]
    
    
    init() {
        apps = .init()
        modules = .init()
        cacheModule = NSMapTable<NSString, AnyObject>.init(keyOptions: .strongMemory, valueOptions: .weakMemory)
        subscribers = .init()
        registered = .init()
        
    }
}
