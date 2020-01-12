//
//  ContentTopView.swift
//  CreateJSONFile
//
//  Created by Lj on 2020/1/11.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class ContentTopView: NSView {


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
        
    }
}
