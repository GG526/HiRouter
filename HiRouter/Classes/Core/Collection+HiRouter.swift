//
//  Collection+HiRouter.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2021/12/30.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
