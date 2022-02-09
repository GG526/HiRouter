//
//  Entity.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2021/12/30.
//

import Foundation

class Entity {
    
    var apps: [String] = .init()
    var modules: [String: Router] = .init()
    var subscribers: [String: [RouterObserver]] = .init()
    
    
    init() {
        
    }
    
}
