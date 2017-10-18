//
//  ViewController.swift
//  UserTracker
//
//  Created by MooYoo on 10/18/2017.
//  Copyright (c) 2017 MooYoo. All rights reserved.
//

import UIKit
import UserTracker

class ViewController: UIViewController {
    
    @objc dynamic func clickButton(text: String) {
        // do sth
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clickButton(text: "arguments")
    }
}

extension ViewController: Trackable {
    var pageName: String {
        return "首页"
    }
    
    var pageParams: String {
        return "pageParmas"
    }
    var methods: [(Selector,TrackBlock)] {
        return [(#selector(clickButton), { args in
            UserTracker.action(name: "点击XX按钮", params: ["text": (args.first as? String) ?? ""], in: self)
        })]
    }
}



