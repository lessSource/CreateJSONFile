//
//  MainLeftView.swift
//  CreateJSONFile
//
//  Created by L j on 2020/6/11.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class MainLeftView: ContentView {

    fileprivate lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: self.width, height: self.height))
        scrollView.autoresizingMask = [.height, .width]
        return scrollView
    }()
    
    fileprivate lazy var tableView: NSTableView = {
        let tableView = NSTableView(frame: NSRect(x: 0, y: 0, width: self.width, height: self.height))
        tableView.autoresizingMask = [.height, .width]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.selectionHighlightStyle = .none
        tableView.rowSizeStyle = .large
        tableView.headerView = nil
        return tableView
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - initView
    fileprivate func initView() {
        let keyColumn: NSTableColumn = NSTableColumn()
        keyColumn.identifier = "keyColumn".identifire
        keyColumn.minWidth = self.width
        keyColumn.width = self.width
        keyColumn.title = ""
        tableView.addTableColumn(keyColumn)
        print(tableView.rect(ofColumn: 0))
        scrollView.documentView = tableView
        addSubview(scrollView)
    }
    
}


extension MainLeftView: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 40
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = tableView.makeView(withIdentifier: RequestInputCell.identifire, owner: self) as? RequestInputCell
        if cell == nil {
            cell = RequestInputCell()
            cell?.identifier = RequestInputCell.identifire
        }
        cell?.nameTextField.placeholderString = "dataArray[row].keyPlaceholder\(row)"
        return cell!
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    
}
