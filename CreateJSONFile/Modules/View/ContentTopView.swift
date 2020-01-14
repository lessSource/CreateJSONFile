//
//  ContentTopView.swift
//  CreateJSONFile
//
//  Created by Lj on 2020/1/11.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class ContentTopView: NSView {

    fileprivate lazy var tabView: NSTabView = {
        let tabView = NSTabView(frame: NSRect(x: 0, y: 50, width: self.width, height: self.height))
        tabView.autoresizingMask = [.height, .width]
        tabView.focusRingType = .none
        tabView.tabViewType = .noTabsNoBorder
        return tabView
    }()
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isFlipped: Bool {
        return true
    }
    
    fileprivate func initView() {
        let button = NSButton(title: "按钮", target: self, action: #selector(buttonClick))
        button.frame = NSRect(x: 100, y: 0, width: 100, height: 50)
        addSubview(button)
        
        
        
        let home = HomePopViewController()
        
        let home0 = HomePopViewController()

        
        let item0 = NSTabViewItem(viewController: home)
        item0.view = home.view
        item0.label = "item0"
        
        let item1 = NSTabViewItem(viewController: home0)
        item1.view = home0.view
        item1.label = "item1"
        item1.toolTip = "1212"
        item1.image =  NSImage(named: NSImage.addTemplateName)
        
        tabView.addTabViewItem(item0)
        tabView.addTabViewItem(item1)

        addSubview(tabView)
    }
    
    @objc fileprivate func buttonClick() {
        print("1212")
        tabView.selectTabViewItem(at: 1)
    }
}
