//
//  TabBarViewController.swift
//  HiRouter_Example
//
//  Created by Yang Lanqing on 2022/1/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    //MARK: - typealias
    
    //MARK: - storage
    
    //MARK: - lazy
    lazy var flutter: FlutterController = {
        let vc = FlutterController.init()
        vc.title = "flutter"
        return vc
    }()
    
    lazy var web: WebController = {
        let vc = WebController.init(url: "https://www.baidu.com")
        vc.title = "web"
        return vc
    }()
    
    lazy var native: NativeController = {
        let vc = NativeController.init()
        vc.title = "native"
        return vc
    }()
    //MARK: - calculate
    
    //MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - deinit
    
    //MARK: - life cycle
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [native]
        self.navigationItem.title = native.title
        self.delegate = self
    }
    //MARK: - override
    
    //MARK: - layout
    
    //MARK: - public function
    
    //MARK: - private function
    
}


extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            self.navigationItem.title = viewController.title
    }
}
