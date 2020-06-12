//
//  RequestParamsViewController.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/16.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class RequestParamsViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    fileprivate var dataArray: Array = [RequestHeadersModel()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initView()
    }
    
    fileprivate func initView() {
        tableView.autoresizingMask = [.height, .width]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.selectionHighlightStyle = .none
        tableView.rowSizeStyle = .large
        
        let keyColumn: NSTableColumn = NSTableColumn()
        keyColumn.identifier = "keyColumn".identifire
        keyColumn.minWidth = 100
        keyColumn.width = view.width/3
        keyColumn.title = "KEY"
        tableView.addTableColumn(keyColumn)
        
        let valueColumn: NSTableColumn = NSTableColumn()
        valueColumn.identifier = "valueColumn".identifire
        valueColumn.minWidth = 100
        valueColumn.width = view.width/3
        valueColumn.title = "VALUE"
        tableView.addTableColumn(valueColumn)
        
        let descriptionColumn: NSTableColumn = NSTableColumn()
        descriptionColumn.identifier = "descriptionColumn".identifire
        descriptionColumn.minWidth = 100
        descriptionColumn.width = view.width/3
        descriptionColumn.title = "DESCRIPTION"
        tableView.addTableColumn(descriptionColumn)
        
    }
    
    fileprivate func textFieldChange(_ string: String, tableColumn: NSTableColumn?, row: Int) {
        if tableColumn?.identifier == "keyColumn".identifire {
            dataArray[row].key = string
        }else if tableColumn?.identifier == "valueColumn".identifire {
            dataArray[row].content = string
        }
        if dataArray.last?.key.isEmpty != true {
            dataArray.append(RequestHeadersModel())
        }
        
    }
    
    // MARK: - public
    public func getRequestParams() -> Dictionary<String, String> {
        var dic = [String: String]()
        for item in dataArray {
            if !item.key.isEmpty && !item.content.isEmpty {
                dic.updateValue(item.content, forKey: item.key)
            }
        }
        return dic
    }
    
    
}


extension RequestParamsViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell = tableView.makeView(withIdentifier: RequestInputCell.identifire, owner: self) as? RequestInputCell
        if cell == nil {
            cell = RequestInputCell()
            cell?.identifier = RequestInputCell.identifire
        }
        if tableColumn?.identifier == "keyColumn".identifire {
            cell?.nameTextField.placeholderString = dataArray[row].keyPlaceholder
            cell?.nameTextField.stringValue = dataArray[row].key
        }else if tableColumn?.identifier == "valueColumn".identifire {
            cell?.nameTextField.placeholderString = dataArray[row].contentPlaceholder
            cell?.nameTextField.stringValue = dataArray[row].content
        }else {
            cell?.nameTextField.placeholderString = ""
        }
        cell?.textFieldChangeClosure = { [weak self] str in
            self?.textFieldChange(str, tableColumn: tableColumn, row: row)
        }
        cell?.didSelectButtonClosure = { [weak self] in
            self?.tableView.reloadData()
        }
        return cell!
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
}
