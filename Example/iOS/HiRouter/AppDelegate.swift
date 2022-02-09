//
//  AppDelegate.swift
//  HiRouter
//
//  Created by GG526 on 12/30/2021.
//  Copyright (c) 2021 GG526. All rights reserved.
//

import UIKit
import HiRouter
import Flutter


var flutterEngines: FlutterEngineGroup {
    (UIApplication.shared.delegate as! AppDelegate).engines
}

var topNav: UINavigationController? {
    (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? UINavigationController
}

var topVC: UIViewController? {
    topNav?.topViewController
}

var rootTab: UITabBarController? {
    (topNav as? NavigationViewController)?.tabbar
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let engines = FlutterEngineGroup(name: "multiple-flutters", project: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
    #if DEBUG
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
    #endif
        
        self.routers()
        
        let window = UIWindow.init()
        window.rootViewController = NavigationViewController.init()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if !RouteManager.default.can(open: url) {
            
        }else {
            RouteManager.default.open(url, completion: nil)
        }
        
        return true
    }
}

