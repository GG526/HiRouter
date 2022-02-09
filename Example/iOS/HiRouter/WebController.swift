//
//  WebController.swift
//  HiRouter_Example
//
//  Created by Yang Lanqing on 2022/1/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import HiRouter
import WebKit
import SnapKit

class WebController: UIViewController {
    
    //MARK: - typealias
    
    //MARK: - storage
    let webView: HiWebView
    var url: String = ""
    //MARK: - lazy
    
    //MARK: - calculate
    
    //MARK: - init
    init() {
        webView = HiWebView.init()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    init(url: String) {
        webView = HiWebView.init()
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - deinit
    
    deinit {
        print(#fileID, #function, #line)
    }
    
    //MARK: - life cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Web"
        webView.uiDelegate = self
        webView.routerDelegate = self
        if !url.isEmpty {
            load(url: url)
        }else {
            let baseURL = URL.init(fileURLWithPath: Bundle.main.bundlePath)
            guard let htmlPath = Bundle.main.path(forResource: "web_test", ofType: "html") else {
                return
            }
            do {
                let htmlContent = try String.init(contentsOfFile: htmlPath, encoding: .utf8)
                webView.loadHTMLString(htmlContent, baseURL: baseURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    //MARK: - override
    
    //MARK: - layout
    
    //MARK: - public function
    public func load(url: String) {
        self.url = url
        if !url.isEmpty, let url = URL.init(string: url) {
            webView.load(URLRequest.init(url: url))
        }
    }
    //MARK: - private function
    
}

extension WebController: HiWebDelegate {
    
    func callBackJavaScriptFunction(_ webView: WKWebView) -> String {
        return "execCallback"
    }
    
    func invokeJavaScriptFunction(_ webView: WKWebView) -> String {
        return "dispatchEvent"
    }
    
    func webViewModuleName(_ webView: WKWebView) -> String {
        return "web"
    }
    
    func webViewAppName(_ webView: WKWebView) -> String {
        return app
    }
    
    func webView(_ webView: WKWebView, analytiCallRouterData data: Any?) -> String? {
        return nil
    }
    
}

extension WebController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension WebController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController.init(title: "WebAlert", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "确定", style: .default, handler: nil))
        topVC?.present(alert, animated: true, completion: nil)
        completionHandler()
    }
}
