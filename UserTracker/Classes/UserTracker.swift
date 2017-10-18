//
//  UserTracker.swift
//  SwiftTest
//
//  Created by Alan on 2017/10/17.
//  Copyright © 2017年 Alan. All rights reserved.
//

import UIKit
import Aspects

public typealias TrackBlock = ((_ args:[Any])->Void)

public protocol Trackable {
    var pageName: String {get}
    var pageParams: String {get}
    var methods: [(Selector,TrackBlock)] {get}
    var autoTrack: Bool {get}   // 自动添加enter和out事件
}

public extension Trackable {
    var autoTrack: Bool {
        return true
    }
    
    var methods: [(Selector,TrackBlock)] {
        return []
    }
}

public protocol UserTrackerDelegate {
    func userTrackerDidTrack(pageName: String, pageParams: String?, actionName: String, actionParmas: [String: Any]?)
}

public class UserTracker {
    
    static var delegate: UserTrackerDelegate?
    
    public static func action(name: String, params: [String:Any]?, in page: Trackable) {
        track(pageName: page.pageName, pageParams: page.pageParams, actionName: name, actionParmas: params)
    }
    
    // Baisc
    public static func track(pageName: String, pageParams: String?, actionName: String, actionParmas: [String: Any]?) {
        delegate?.userTrackerDidTrack(pageName: pageName, pageParams: pageParams, actionName: actionName, actionParmas: actionParmas)
    }
    
    // call setup in appDelegate's didFinishedLaunch before all view's operation Because initialize() deprecated in Swift 4.0.
    public static func setup(delegate: UserTrackerDelegate) {
        self.delegate = delegate
        
        UIViewController.swizzledMethod(originalSelector: #selector(UIViewController.viewDidAppear(_:)),
                                        swizzledSelector: #selector(UIViewController.ut_viewDidAppear(animated:)))
        
        UIViewController.swizzledMethod(originalSelector: #selector(UIViewController.viewDidDisappear(_:)),
                                        swizzledSelector: #selector(UIViewController.ut_viewDidDisappear(animated:)))
    }
}

extension UIViewController {
    
    fileprivate static var aspectsTokensKey: String = "UIViewControllerAspectsTokensKey"
    
    var aspectsTokens: [AspectToken] {
        get {
            guard let tokens = objc_getAssociatedObject(self, &UIViewController.aspectsTokensKey) else {
                let emptyTokens: [AspectToken] = []
                objc_setAssociatedObject(self, &UIViewController.aspectsTokensKey, emptyTokens, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return emptyTokens
            }
            return (tokens as? [AspectToken]) ?? []
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.aspectsTokensKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    @objc dynamic func ut_viewDidAppear(animated: Bool) {
        self.ut_viewDidAppear(animated: animated)
        
        guard let trackableSelf = self as? Trackable else {return}
        aspectsTokens = trackableSelf.methods.flatMap({ (selector, aspectBlock) -> AspectToken? in
            let wrappedBlock:@convention(block) (AspectInfo) -> Void = { info in
                aspectBlock(info.arguments())
            }
            return try? self.aspect_hook(selector, with: .init(rawValue: 0), usingBlock: wrappedBlock)
        })
        
        guard trackableSelf.autoTrack else {return}
        UserTracker.track(pageName: trackableSelf.pageName, pageParams: trackableSelf.pageParams, actionName: "enter", actionParmas: nil)
    }
    
    @objc dynamic func ut_viewDidDisappear(animated: Bool) {
        self.ut_viewDidDisappear(animated: animated)
        
        guard let trackableSelf = self as? Trackable else {return}
        aspectsTokens.forEach({$0.remove()})
        
        guard trackableSelf.autoTrack else {return}
        UserTracker.track(pageName: trackableSelf.pageName, pageParams: trackableSelf.pageParams, actionName: "out", actionParmas: nil)
    }
    
    // 仅适用于swift 4.0以下版本
//    override open static func initialize() {
//
//        // 仅交换UIViewController的方法，子类不交换
//        guard self == UIViewController.self else {return}
//
//        DispatchQueue.once(token: UUID().uuidString) {
//            swizzledMethod(originalSelector: #selector(UIViewController.viewDidAppear(_:)),
//                           swizzledSelector: #selector(UIViewController.ut_viewDidAppear(animated:)))
//
//            swizzledMethod(originalSelector: #selector(UIViewController.viewDidDisappear(_:)),
//                           swizzledSelector: #selector(UIViewController.ut_viewDidDisappear(animated:)))
//        }
//    }
    
    fileprivate static func swizzledMethod(originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(self, originalSelector) else {return}
        guard let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else {return}
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}








