//
//  Router.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2021/12/30.
//

import Foundation

public protocol Router: AnyObject {
    var module: String { get }
    var supportMethods: [String] { get }
    
    func router(_ router: RouteManager, open method: String, port: Int?, options: Any?, completion: ((Any?) -> Void)?) -> Bool
    
}

public protocol RouterObserver: AnyObject {
    var module: String { get }
    
    func router(_ router: RouteManager, invoke method: String, port: Int?, options: Any?, completion: ((Any?) -> Void)?) -> Bool
}
