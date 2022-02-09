//
//  HiWebView.swift
//  HiRouter
//
//  Created by Yang Lanqing on 2022/1/4.
//

import Foundation
import WebKit

open class HiWebView: WKWebView, HiQueue {
    
    //MARK: - typealias
    
    //MARK: - storage
    weak open var routerDelegate: HiWebDelegate?
    private var proxy: HiWebProxy?
    //MARK: - lazy
    
    //MARK: - calculate
    
    public var executeFunction: String {
        guard let value = self.routerDelegate?.callBackJavaScriptFunction(self), !value.isEmpty else {
            return "ExecuteFunction"
        }
        return value
    }
    public var invokeFunction: String {
        guard let value = self.routerDelegate?.invokeJavaScriptFunction(self), !value.isEmpty else {
            return "InvokeFunction"
        }
        return value
    }
    //MARK: - init
    
    override public init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        proxy = .init(delegate: self)
        navigationDelegate = proxy
        RouteManager.default.add(observer: self)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - deinit
    deinit {
        RouteManager.default.remove(observer: self)
        HiPrint("deinit")
    }
    
    //MARK: - override
    open override var navigationDelegate: WKNavigationDelegate? {
        didSet {
            if navigationDelegate === proxy {
                return
            }
            proxy?.target = navigationDelegate
            navigationDelegate = proxy
        }
    }
    //MARK: - layout
    
    //MARK: - public function
    
    //MARK: - private function
    
    private func enaluate(javaScript js: String, completion: ((Any?, Error?) -> Void)?) {
        executeInMain { [weak self] in
            guard let `self` = self else {
                return
            }
            self.evaluateJavaScript(js, completionHandler: completion)
        }
    }
    
    private func callBack(javaScript result: Any?, port: Int?) {
        
        func fetchJS(_ value: String) -> String {
            if let port = port, port > 0 {
                return "\(self.executeFunction)(\(port),\(value))"
            }
            return "\(self.executeFunction)(\(value))"
        }
        
        guard let result = result else {
            return
        }
        var javaScript: String = ""
        if let js = self.routerDelegate?.webView(self, analytiCallRouterData: result), !js.isEmpty {
            javaScript = fetchJS(js)
        }
        if let js = result as? String, !js.isEmpty {
            javaScript = fetchJS(js)
        }
        if JSONSerialization.isValidJSONObject(result) {
            let json = jsonSerialization(data: result)
            if !json.isEmpty {
                javaScript = fetchJS(json)
            }
        }
        if !javaScript.isEmpty {
            self.enaluate(javaScript: javaScript, completion: nil)
            return
        }
        assert(true, "Calling java script cannot parse the data!")
    }
    
    // invoke to js
    fileprivate func invoke(javaScript options: [String: Any]?, port: Int?, method: String, completion: ((Any?) -> Void)?) {
        
        var value = ""
        if let options = options,
           let data = try? JSONSerialization.data(withJSONObject: options, options: []),
           let json = String.init(data: data, encoding: .utf8),
           !json.isEmpty{
            
            value = json
        }
        
        let javaScript = "\(self.invokeFunction)(\(method),\(value)"
        self.enaluate(javaScript: javaScript, completion: {
            if let errror = $1 {
                completion?(errror)
                return
            }
            completion?($0)
        })
    }
    
    // json
    fileprivate func jsonSerialization(data: Any) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: data, options: [])
            let json = String.init(data: data, encoding: .utf8)
            if let json = json, !json.isEmpty {
                return json
            }else {
                HiPrint("json empty!", level: .ERROR)
                return ""
            }
        }catch {
            HiPrint(error.localizedDescription, level: .ERROR)
            return ""
        }
    }
}

////MARK: - RouterObserver
extension HiWebView: RouterObserver {
    public var module: String {
        if let name = self.routerDelegate?.webViewModuleName(self), !name.isEmpty {
            return name
        }
        return "web"
    }
    
    public func router(_ router: RouteManager, invoke method: String, port: Int?, options: [String : Any]?, completion: ((Any?) -> Void)?) -> Bool {
        self.invoke(javaScript: options, port: port, method: method, completion: completion)
        return true
    }
}

//MARK: - HiProxyDelegate
extension HiWebView: HiProxyDelegate {
    func proxy(_ proxy: HiWebProxy, openRouter url: URL) -> Bool {
        
        assert(routerDelegate != nil, "\(LogLevel.FATAL) 未设置routerDelegate!!")
        
        guard let webScheme = url.scheme, !webScheme.isEmpty, let routerScheme = routerDelegate?.webViewAppName(self), !routerScheme.isEmpty else {
            return false
        }
        
        guard webScheme.lowercased() == routerScheme.lowercased() else {
            return false
        }
        
        let webUrlString = url.absoluteString.replacingOccurrences(of: webScheme, with: routerScheme)
        
        guard let newWebUrl = URL.init(string: webUrlString) else {
            return false
        }
        
        RouteManager.default.open(newWebUrl, completion: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.callBack(javaScript: $0, port: url.port)
        })
        
        return true
    }
}

