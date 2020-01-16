//
//  RequestParamsViewController.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/16.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class RequestParamsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.randomColor.cgColor
    }
    
}
