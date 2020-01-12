//
//  ContentBottomView.swift
//  CreateJSONFile
//
//  Created by Lj on 2020/1/11.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class ContentBottomView: NSView {
    
    fileprivate lazy var conetntScrollView: NSScrollView = {
        let scroll = NSScrollView(frame: NSRect(x: 0, y: 0, width: self.width, height: self.height))
        scroll.autoresizingMask = [.height, .width]
        return scroll
    }()
    
    
    fileprivate lazy var contentOutlineView = ContentOutlineView(frame: NSRect(x: 0, y: 201, width: self.width, height: self.height - 201))
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    override var isFlipped: Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initView() {
        contentOutlineView.autoresizingMask = [.height, .width]
        contentOutlineView.selectionHighlightStyle = .none
        contentOutlineView.usesAlternatingRowBackgroundColors = true
        contentOutlineView.delegate = self
        contentOutlineView.dataSource = self
        contentOutlineView.rowSizeStyle = .large
        conetntScrollView.documentView = contentOutlineView
        getTableColumn()
        
        addSubview(conetntScrollView)
        
        contentOutlineView.reloadData()
    }
    
    fileprivate func getTableColumn() {
        let keyColumn = NSTableColumn()
        keyColumn.identifier = keyColumn.className.identifire
        keyColumn.title = "key"
        keyColumn.width = 100
        keyColumn.minWidth = 100
        contentOutlineView.addTableColumn(keyColumn)
        
        let stateColumn = NSTableColumn()
        stateColumn.identifier = stateColumn.className.identifire
        stateColumn.title = "忽略"
        stateColumn.width = 44
        stateColumn.minWidth = 44
        contentOutlineView.addTableColumn(stateColumn)
        
        let outputTypeColumn = NSTableColumn()
        outputTypeColumn.identifier = outputTypeColumn.className.identifire
        outputTypeColumn.title = "输出类型"
        outputTypeColumn.width = 120
        outputTypeColumn.minWidth = 120
        contentOutlineView.addTableColumn(outputTypeColumn)
        
        
        let defaultColumn = NSTableColumn()
        defaultColumn.identifier = defaultColumn.className.identifire
        defaultColumn.title = "默认值"
        defaultColumn.width = 100
        defaultColumn.minWidth = 100
        contentOutlineView.addTableColumn(defaultColumn)
        
        let annotationColumn = NSTableColumn()
        annotationColumn.identifier = annotationColumn.className.identifire
        annotationColumn.title = "注释"
        annotationColumn.width = width - 388
        annotationColumn.minWidth = 100
        contentOutlineView.addTableColumn(annotationColumn)
    }
    
}


extension ContentBottomView: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return 100
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return "121"
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
}
