//
//  PageMissingViewController.swift
//  HiRouter_Example
//
//  Created by Yang Lanqing on 2022/1/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PageMissingViewController: UIViewController {
    
    //MARK: - typealias
    
    //MARK: - storage
    let app: String
    let module: String
    let method: String
    //MARK: - lazy
    
    lazy var contentLable: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    
    //MARK: - calculate
    
    //MARK: - init
    init(_ app: String, module: String, method: String) {
        self.app = app
        self.module = module
        self.method = method
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - deinit
    
    //MARK: - life cycle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        view.addSubview(contentLable)
        contentLable.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLable.text =
        """
        404
        \(app)://\(module)\(method)
        """
    }
    
    //MARK: - override
    
    //MARK: - layout
    
    //MARK: - public function
    
    //MARK: - private function
    
}
