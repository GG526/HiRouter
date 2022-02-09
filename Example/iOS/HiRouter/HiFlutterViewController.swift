//
//  HiFlutterViewController.swift
//  HiRouter_Example
//
//  Created by Yang Lanqing on 2022/1/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Flutter
import HiRouter
import FlutterPluginRegistrant

open class HiFlutterViewController: FlutterViewController, RouterObserver {
    
    //MARK: - typealias
    
    //MARK: - storage
    private var channel: FlutterMethodChannel?
    //MARK: - lazy
    
    //MARK: - calculate
    public var module: String {
        "Flutter"
    }
    //MARK: - init
    
    
    public init(withEntrypoint entryPoint: String?) {
        let engine = flutterEngines.makeEngine(withEntrypoint: entryPoint, libraryURI: nil)
        GeneratedPluginRegistrant.register(with: engine)
        super.init(engine: engine, nibName: nil, bundle: nil)
        RouteManager.default.add(observer: self)
    }
    
    deinit {
        RouteManager.default.remove(observer: self)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        channel = FlutterMethodChannel(name: "multiple-flutters", binaryMessenger: self.engine!.binaryMessenger)
        
        channel?.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if let url = URL.init(string: call.method) {
                RouteManager.default.open(url, completion: {
                    result($0)
                })
            }else {
                RouteManager.default.unfoundRouter("", module: "", method: "")
            }
        }
    }
    
    //MARK: - deinit
    
    //MARK: - life cycle
    
    //MARK: - override
    
    //MARK: - layout
    
    //MARK: - public function
    
    //MARK: - private function
    
    //MARK: - RouterObserver
    
    public func router(_ router: RouteManager, invoke method: String, port: Int?, options: [String : Any]?, completion: ((Any?) -> Void)?) -> Bool {
        channel?.invokeMethod(method, arguments: options, result: { result in
            completion?(result)
        })
        return true
    }
}
