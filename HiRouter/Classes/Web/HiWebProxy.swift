//
//  HiWebProxy.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2022/1/14.
//

import Foundation
import WebKit
import ObjectiveC


class HiWebProxy: NSObject, WKNavigationDelegate, HiQueue {
    //MARK: - typealias
    
    //MARK: - storage
    weak var target: WKNavigationDelegate?
    weak var delegate: HiProxyDelegate?
    //MARK: - lazy
    
    //MARK: - calculate
    
    //MARK: - init
    override init() {
        super.init()
    }
    
    init(delegate: HiProxyDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    //MARK: - deinit
    deinit {
        HiPrint("deinit")
    }
    //MARK: - override
    
    //MARK: - public function
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      
        func callTarget() {
            if target?.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler) == nil {
                decisionHandler(.allow)
            }
        }
        
        executeInMain { [weak self] in
            guard let `self` = self else {
                return
            }
            guard let url = navigationAction.request.url else {
                callTarget()
                return
            }
            let status = self.delegate?.proxy(self, openRouter: url) ?? false
            if status {
                decisionHandler(.cancel)
            }
            callTarget()
        }
    }
  
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {

        func callTarget() {
            guard  target?.webView?(webView, decidePolicyFor: navigationAction, preferences: preferences, decisionHandler: decisionHandler) == nil else {
                return
            }
            
            guard target?.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: { policy in decisionHandler(policy, preferences) }) == nil else {
                return
            }
            
            decisionHandler(.allow, preferences)
        }
        
        executeInMain { [weak self] in
            guard let `self` = self else {
                return
            }
            guard let url = navigationAction.request.url else {
                callTarget()
                return
            }
            let status = self.delegate?.proxy(self, openRouter: url) ?? false
            guard !status else {
                decisionHandler(.cancel, preferences)
                return
            }
            callTarget()
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard self.target?.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler) == nil else {
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.target?.webView?(webView, didStartProvisionalNavigation: navigation)
    }

    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        self.target?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.target?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.target?.webView?(webView, didCommit: navigation)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.target?.webView?(webView, didFinish: navigation)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.target?.webView?(webView, didFail: navigation, withError: error)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard self.target?.webView?(webView, didReceive: challenge, completionHandler: completionHandler) == nil else {
            return
        }
        completionHandler(.useCredential, nil)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.target?.webViewWebContentProcessDidTerminate?(webView)
    }
    
    @available(iOS 14.0, *)
    func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
        self.target?.webView?(webView, authenticationChallenge: challenge, shouldAllowDeprecatedTLS: decisionHandler)
    }
    
    @available(iOS 14.5, *)
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        self.target?.webView?(webView, navigationAction: navigationAction, didBecome: download)
    }

    @available(iOS 14.5, *)
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        self.target?.webView?(webView, navigationResponse: navigationResponse, didBecome: download)
    }
    
    //MARK: - private function
    private func isContain(sel: Selector, cls: AnyClass) -> Bool {
        var count: UInt32 = 0
        guard let methodList = class_copyMethodList(cls, &count) else {
            return false
        }
        
        for i in 0..<count {
            let method = methodList[Int(i)]
            let methodString = String.init(utf8String: sel_getName(method_getName(method)))
            if methodString == NSStringFromSelector(sel) {
                return true
            }
        }
        return false
    }
    
    //MARK: - define
}


protocol HiProxyDelegate: AnyObject {
    func proxy(_ proxy: HiWebProxy, openRouter url: URL) -> Bool
}


