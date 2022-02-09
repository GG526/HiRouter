//
//  Lock.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2021/10/13.
//

import Foundation

private protocol LockProtocol {
    func lock()
    func unlock()
}

@available(iOS 10.0, *)
fileprivate class UnfairLock: LockProtocol {
    private let unfairLock: os_unfair_lock_t

    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    fileprivate func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    fileprivate func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}

fileprivate class NLock: LockProtocol {
    private let nslock: NSLock
    
    init() {
        nslock = NSLock()
    }
    
    fileprivate func lock() {
        nslock.lock()
    }
    
    fileprivate func unlock() {
        nslock.unlock()
    }
}


class Lock {
    
    //MARK: - typealias
    
    //MARK: - storage
    private lazy var paymentLock: LockProtocol = {
        if #available(iOS 10.0, *) {
            return UnfairLock()
        }else {
            return NLock()
        }
    }()
    //MARK: - lazy
    
    //MARK: - calculate
    
    //MARK: - init
    
    //MARK: - deinit
    
    //MARK: - layout
    
    //MARK: - public function
    
    func lock() {
        paymentLock.lock()
    }
    func unlock() {
        paymentLock.unlock()
    }
    
    func sync(_ closure: () -> ()) {
        lock()
        closure()
        unlock()
    }
    //MARK: - private function
}
