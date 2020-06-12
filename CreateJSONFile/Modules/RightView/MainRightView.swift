//
//  MainRightView.swift
//  CreateJSONFile
//
//  Created by Lj on 2020/1/10.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import SwiftyJSON

class MainRightView: ContentView {
    
    fileprivate lazy var contentSplitView: ContentSplitView = {
        let splitView = ContentSplitView(frame: CGRect(x: 15, y: 90, width: self.width - 30, height: self.height - 90))
        splitView.autoresizingMask = [.height, .width]
        splitView.dividerStyle = .thin
        splitView.delegate = self
        return splitView
    }()
    
    fileprivate lazy var topView: FileOperationsView = {
        let view = FileOperationsView(frame: NSRect(x: 15, y: 0, width: self.width - 30, height: 100))
        view.autoresizingMask = [.width]
        view.dataSource = self
        view.delegate = self
        return view
    }()
        
    fileprivate lazy var contentTopView: ContentTopView = {
        let bottomView = ContentTopView(frame: NSRect(x: 15, y: 100, width: self.width - 30, height: 200))
        bottomView.autoresizingMask = [.height, .width]
        return bottomView
    }()
    
    fileprivate lazy var contentBottomView: ContentBottomView = {
        let bottomView = ContentBottomView(frame: NSRect(x: 15, y: 300, width: self.width - 30, height: self.height - 300))
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
        addSubview(topView)
    }
    
}

extension MainRightView: FileOperationsDataSource, FileOperationsDelegate {
    func fileOperationsGetBody(_ view: FileOperationsView) -> Dictionary<String, Any> {
        return contentTopView.getContentTopBody()
    }
    
    func fileOperationsGetParams(_ view: FileOperationsView) -> Dictionary<String, Any> {
        return contentTopView.getContentTopParams()
    }
    
    func fileOperationsGetHeader(_ view: FileOperationsView) -> Dictionary<String, String> {
        return contentTopView.getContentTopHerader()
    }
    
    func fileOperationGetJsonStr(_ view: FileOperationsView) -> String {
        return contentTopView.getContentTopJson()
    }
    
    func fileOperationGetModel(_ view: FileOperationsView) -> [HomeContentModel] {
        return contentBottomView.getContentBottomContentModel()
    }
    
    func fileOperationsView(_ view: FileOperationsView, json: JSON) {
        contentTopView.setContentTopContent(json)
        contentBottomView.setContentBottomContent(json)
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
