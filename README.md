# HiRouter

[![CI Status](https://img.shields.io/travis/GG526/HiRouter.svg?style=flat)](https://travis-ci.org/GG526/HiRouter)
[![Version](https://img.shields.io/cocoapods/v/HiRouter.svg?style=flat)](https://cocoapods.org/pods/HiRouter)
[![License](https://img.shields.io/cocoapods/l/HiRouter.svg?style=flat)](https://cocoapods.org/pods/HiRouter)
[![Platform](https://img.shields.io/cocoapods/p/HiRouter.svg?style=flat)](https://cocoapods.org/pods/HiRouter)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

HiRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HiRouter', :git => 'https://github.com/GG526/HiRouter.git',:tag => '1.0.0'
```

## Author

GG526, lanqing0326@gmail.com

## 模块 Router
```
class NativeRouter: Router {
    var module: String {
        "native"
    }

    var supportMethods: [String] {
        return [
            Method.openWeb.rawValue,
            Method.openNative.rawValue,
            Method.openFlutter.rawValue,
        ]
    }

    func router(_ router: RouteManager, open method: String, port: Int?, options: [String : Any]?, completion: ((Any?) -> Void)?) -> Bool {
        switch method {
            case Method.openWeb.rawValue:
                let url = options?["url"] as? String
                topNav?.pushViewController(WebController.init(url: url ?? ""), animated: true)
                return true
            case Method.openNative.rawValue:
                topNav?.pushViewController(NativeController.init(), animated: true)
                return true
            case Method.openFlutter.rawValue:
                topNav?.pushViewController(HiFlutterViewController.init(withEntrypoint: ""), animated: true)
                return true
            default:
                break
        }
        return false
    }



    enum Method: String {
        case openFlutter = "/open/flutter", openWeb = "/open/web", openNative = "/open/native"
    }

}

```
## 注册 Router
```
RouteManager.default.register(app: app, router: NativeRouter.init())
```
## License

HiRouter is available under the MIT license. See the LICENSE file for more info.
