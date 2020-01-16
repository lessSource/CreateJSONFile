//
//  RequestHeadersViewController.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/16.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class RequestHeadersViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initView()
    }
    
    fileprivate func initView() {
        tableView.autoresizingMask = [.height, .width]
        
        let keyColumn: NSTableColumn = NSTableColumn()
        keyColumn.identifier = keyColumn.className.identifire
        keyColumn.minWidth = 100
        keyColumn.width = view.width/3
        keyColumn.title = "KEY"
        tableView.addTableColumn(keyColumn)
        
        let valueColumn: NSTableColumn = NSTableColumn()
        valueColumn.identifier = valueColumn.className.identifire
        valueColumn.minWidth = 100
        valueColumn.width = view.width/3
        valueColumn.title = "VALUE"
        tableView.addTableColumn(valueColumn)
        
        let descriptionColumn: NSTableColumn = NSTableColumn()
        descriptionColumn.identifier = descriptionColumn.className.identifire
        descriptionColumn.minWidth = 100
        descriptionColumn.width = view.width/3
        descriptionColumn.title = "DESCRIPTION"
        tableView.addTableColumn(descriptionColumn)

    }
    
}
