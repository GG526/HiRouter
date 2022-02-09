//
//  NavigationViewController.swift
//  HiRouter_Example
//
//  Created by Yang Lanqing on 2022/1/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewController: UINavigationController {
    
    //MARK: - typealias
    
    //MARK: - storage
    weak var tabbar: TabBarViewController?
    //MARK: - lazy
    
    //MARK: - calculate
    
    //MARK: - init
    init() {
        let vc = TabBarViewController.init()
        super.init(rootViewController: vc)
        self.tabbar = vc
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - deinit
    
    //MARK: - life cycle
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - override
    
    //MARK: - layout
    
    //MARK: - public function
    
    //MARK: - private function
    
}



