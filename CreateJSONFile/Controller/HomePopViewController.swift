//
//  HomePopViewController.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/6.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class HomePopViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func loadView() {
        let frame = NSApplication.shared.mainWindow?.frame
        self.view = ContentView(frame: frame ?? NSRect.zero)
    }
    
}
