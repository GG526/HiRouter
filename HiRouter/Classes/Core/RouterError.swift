//
//  RouterError.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2021/12/30.
//

import Foundation

enum RouterError: Error {
    case unfoundApp
    case unfoundModule
    case unfoundMethod
    case unfoundRouter
    case unfoundObserver
}

extension RouterError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .unfoundApp:
                return "未找到APP"
            case .unfoundModule:
                return "未找到Module"
            case .unfoundMethod:
                return "未找到Method"
            case .unfoundRouter:
                return "路由未注册"
            case .unfoundObserver:
                return "没有订阅者"
        }
    }
}
