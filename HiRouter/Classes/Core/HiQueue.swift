//
//  HiQueue.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2022/1/24.
//

import Foundation
import Dispatch

protocol HiQueue {
    func execute(queue: DispatchQueue, closure: @escaping () -> Void)
    func executeInMain(closure: @escaping () -> Void)
}


extension HiQueue {
    func execute(queue: DispatchQueue, closure: @escaping () -> Void) {
        queue.async {
            closure()
        }
    }

    func executeInMain(closure: @escaping () -> Void) {
        execute(queue: DispatchQueue.main, closure: closure)
    }
}
