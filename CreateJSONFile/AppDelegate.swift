//
//  AppDelegate.swift
//  CreateJSONFile
//
//  Created by less on 2019/12/31.
//  Copyright © 2019 Less. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1000, height: 800), styleMask: style, backing: .buffered, defer: true)
        window?.title = "JSONModel"
        window?.minSize = NSSize(width: 700, height: 500)
        
//        window.is
        window?.makeKeyAndOrderFront(nil)
        window?.center()
        window?.contentViewController = HomeViewController()
      
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

