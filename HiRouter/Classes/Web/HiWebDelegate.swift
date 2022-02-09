//
//  HiWebDelegate.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2022/1/4.
//

import Foundation
import WebKit

public protocol HiWebDelegate: AnyObject {
    
    /// 异步执行回调js的方法名(default: ExecuteFunction).
    /// - Returns: 方法名.
    func callBackJavaScriptFunction(_ webView: WKWebView) -> String
    
    /// 主动调用js方法的方法名(default: InvokeFunction).
    /// - Returns: 方法名.
    func invokeJavaScriptFunction(_ webView: WKWebView) -> String
    
    /// Web的模块名(default: web).
    /// - Returns: 模块名.
    func webViewModuleName(_ webView: WKWebView) -> String
    
    /// App名字
    /// - Returns: App
    func webViewAppName(_ webView: WKWebView) -> String
    
    /// 解析router回调数据.
    /// 如果返回空或者nil, 则按照string和isValidJSONObject解析两次, 不过不能解析报错.
    /// - Returns: 解析后js的接收的数据格式.
    func webView(_ webView: WKWebView, analytiCallRouterData data: Any?) -> String?
    
}
