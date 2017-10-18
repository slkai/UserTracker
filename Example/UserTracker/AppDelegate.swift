//
//  AppDelegate.swift
//  UserTracker
//
//  Created by MooYoo on 10/18/2017.
//  Copyright (c) 2017 MooYoo. All rights reserved.
//

import UIKit
import UserTracker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserTracker.setup(delegate: self)
        return true
    }
}

extension AppDelegate: UserTrackerDelegate {
    func userTrackerDidTrack(pageName: String, pageParams: String?, actionName: String, actionParmas: [String : Any]?) {
        print("\n pageName: \(pageName) \n pageParams: \(pageParams ?? "") \n actionName: \(actionName) \n actionParams: \(actionParmas ?? [:])")
    }
}

