//
//  Log.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2022/1/25.
//

import Foundation

func HiPrint(_ items: Any..., level: LogLevel = .DEBUG, fileID: String = #fileID, function: String = #function, line: Int = #line) {
    guard level != .OFF else {
        return
    }
    #if DEBUG
    print(level, "[\(fileID)-\(function)-\(line)]:", items)
    #endif
}


enum LogLevel: Int {
    case OFF, DEBUG, INFO, WARN, ERROR, FATAL
}

extension LogLevel: CustomStringConvertible {
    var description: String {
        switch self {
            case .OFF:
                return "🔕"
            case .DEBUG:
                return "⚪️"
            case .INFO:
                return "🔵"
            case .WARN:
                return "🟠"
            case .ERROR:
                return "🔴"
            case .FATAL:
                return "💔"
        }
    }
}
