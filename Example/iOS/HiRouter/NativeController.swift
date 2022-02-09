//
//  NativeController.swift
//  HiRouter
//
//  Created by GG526 on 12/30/2021.
//  Copyright (c) 2021 GG526. All rights reserved.
//

import UIKit
import SnapKit
import HiRouter

class NativeController: UIViewController {
    
    //MARK: - typealias
    
    //MARK: - storage
    
    //MARK: - lazy
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .white
        view.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    
    
    //MARK: - calculate
    //MARK: - init
    
    //MARK: - deinit
    
    //MARK: - life cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Native"
        tableView.reloadData()
    }
    
    
    //MARK: - override
    
    //MARK: - layout
    
    //MARK: - public function
    
    //MARK: - private function
    
    //MARK: - define
    enum Menu: Int, CustomStringConvertible {
        case open404, openFlutter, openNative, openWeb, end
        
        var description: String {
            switch self {
                case .openWeb:
                    return "web"
                case .openFlutter:
                    return "flutter"
                case .openNative:
                    return "native"
                case .open404:
                    return "404"
                case .end:
                    return "end"
            }
        }
        
        var router: URL? {
            switch self {
                case .open404:
                    return URL.init(string: "\(app)://native/open/404")
                case .openFlutter:
                    return URL.init(string: app + "://native/open/flutter")
                case .openNative:
                    return URL.init(string: app + "://native/open/native")
                case .openWeb:
                    return URL.init(string: "\(app)://native/open/web")
                case .end:
                    return nil
            }
        }
    }
}

extension NativeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Menu.end.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = Menu.init(rawValue: indexPath.row)?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = Menu.init(rawValue: indexPath.row)?.router {
            RouteManager.default.open(url)
        }
    }
}


