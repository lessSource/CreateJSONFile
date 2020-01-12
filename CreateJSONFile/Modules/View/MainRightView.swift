//
//  MainRightView.swift
//  CreateJSONFile
//
//  Created by Lj on 2020/1/10.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class MainRightView: NSView {
    
    fileprivate lazy var contentSplitView: ContentSplitView = {
        let splitView = ContentSplitView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        splitView.autoresizingMask = [.height, .width]
        splitView.dividerStyle = .thin
        splitView.delegate = self
        return splitView
    }()
        
    fileprivate lazy var contentTopView: ContentTopView = {
        let bottomView = ContentTopView(frame: NSRect(x: 0, y: 0, width: self.width, height: 200))
        bottomView.autoresizingMask = [.height, .width]
        bottomView.wantsLayer = true
        bottomView.layer?.backgroundColor = NSColor.randomColor.cgColor
        return bottomView
    }()
    
    fileprivate lazy var contentBottomView: ContentBottomView = {
        let bottomView = ContentBottomView(frame: NSRect(x: 0, y: 201, width: self.width, height: self.height - 201))
        bottomView.autoresizingMask = [.height, .width]
        return bottomView
    }()
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initView() {
        contentSplitView.addArrangedSubview(contentTopView)
        contentSplitView.addArrangedSubview(contentBottomView)
        addSubview(contentSplitView)
        
    }
    
}

extension MainRightView: NSSplitViewDelegate {
    
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 200
    }
    
    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 500
    }
    
    func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        if view == splitView.subviews[1] {
            return true
        }
        return false
    }
}
