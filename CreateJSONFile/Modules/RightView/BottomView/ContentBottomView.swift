//
//  ContentBottomView.swift
//  CreateJSONFile
//
//  Created by Lj on 2020/1/11.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import SwiftyJSON

struct ContentBottomKey {
    static let key = "keyColumn".identifire
    static let state = "stateColumn".identifire
    static let outputType = "outputTypeColumn".identifire
    static let patientia = "defaultColumn".identifire
    static let annotation = "annotationColumn".identifire
}

class ContentBottomView: NSView {
    
    fileprivate lazy var conetntScrollView: NSScrollView = {
        let scroll = NSScrollView(frame: NSRect(x: 0, y: 0, width: self.width, height: self.height - 15))
        scroll.autoresizingMask = [.height, .width]
        return scroll
    }()
    
    
    fileprivate lazy var contentOutlineView = ContentOutlineView(frame: NSRect(x: 0, y: 201, width: self.width, height: self.height - 201))
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    fileprivate var dataArray: Array = [HomeContentModel]()
    
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
        keyColumn.identifier = ContentBottomKey.key
        keyColumn.title = "key"
        keyColumn.width = 100
        keyColumn.minWidth = 100
        contentOutlineView.addTableColumn(keyColumn)
        
        let stateColumn = NSTableColumn()
        stateColumn.identifier = ContentBottomKey.state
        stateColumn.title = "忽略"
        stateColumn.width = 44
        stateColumn.minWidth = 44
        contentOutlineView.addTableColumn(stateColumn)
        
        let outputTypeColumn = NSTableColumn()
        outputTypeColumn.identifier = ContentBottomKey.outputType
        outputTypeColumn.title = "输出类型"
        outputTypeColumn.width = 120
        outputTypeColumn.minWidth = 120
        contentOutlineView.addTableColumn(outputTypeColumn)
        
        
        let defaultColumn = NSTableColumn()
        defaultColumn.identifier = ContentBottomKey.patientia
        defaultColumn.title = "默认值"
        defaultColumn.width = 100
        defaultColumn.minWidth = 100
        contentOutlineView.addTableColumn(defaultColumn)
        
        let annotationColumn = NSTableColumn()
        annotationColumn.identifier = ContentBottomKey.annotation
        annotationColumn.title = "注释"
        annotationColumn.width = width - 388
        annotationColumn.minWidth = 100
        contentOutlineView.addTableColumn(annotationColumn)
    }
    
    // MARK: - public
    public func setContentBottomContent(_ json: JSON) {
        print(json.type)
        
        switch json.type {
        case .dictionary:
            let array = FileDataModel.formattingJSON(json.dictionaryObject ?? [String: Any]())
            dataArray = array
        case .array:
            let arr = json.arrayObject ?? [Any]()
            let array = FileDataModel.formattingJSON(["NamrArr": arr])
            dataArray = array
        default:
            break
        }
        contentOutlineView.reloadData()
    }
    
    public func getContentBottomContentModel() -> [HomeContentModel] {
        return dataArray
    }
    
    // MARK: - fileprivate
    fileprivate func updatValue(_ string: String, tableColumn: NSTableColumn?, item: Any) {
        if let model = item as? HomeContentModel {
            if tableColumn?.identifier == ContentBottomKey.patientia {
                model.defaultStr = string
            }else if tableColumn?.identifier == ContentBottomKey.annotation {
                model.annotation = string
            }
        }
    }
    
    fileprivate func updateDataType(_ item: Any) {
        guard let model = item as? HomeContentModel else {
            return
        }
        switch model.outputType {
        case .array(_): model.defaultStr = "[String]()"
        case .bool: model.defaultStr = "false"
        case .dictionary(_): model.defaultStr = "[String: Any]()"
        case .int: model.defaultStr = "0"
        case .string: model.defaultStr = "\"\""
        }
        contentOutlineView.reloadItem(item)
    }
    
}


extension ContentBottomView: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let model = item as? HomeContentModel {
            return model.childArr.count
        }else {
            return dataArray.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let model = item as? HomeContentModel {
            return model.childArr[index]
        }else {
            return dataArray[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let model = item as? HomeContentModel {
            return model.childArr.count > 0
        }else {
            return dataArray.count > 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let model = item as? HomeContentModel else { return nil }
        
        switch tableColumn?.identifier {
        case ContentBottomKey.state:
            var cell = outlineView.makeView(withIdentifier: HomeIgnoreTableViewCell.identifire, owner: self) as? HomeIgnoreTableViewCell
            if cell == nil {
                cell = HomeIgnoreTableViewCell()
                cell?.identifier = HomeIgnoreTableViewCell.identifire
            }
            cell?.model = model
            return cell
        case ContentBottomKey.outputType:
            var cell = outlineView.makeView(withIdentifier: HomeTypeTableCellView.identifire, owner: self) as? HomeTypeTableCellView
            if cell == nil {
                cell = HomeTypeTableCellView()
                cell?.identifier = HomeTypeTableCellView.identifire
            }
            cell?.model = model
            cell?.didSelectCheck = { [weak self] in
                self?.updateDataType(item)
            }
            return cell
        default:
            var cell = outlineView.makeView(withIdentifier: HomeTableViewCell.identifire, owner: self) as? HomeTableViewCell
            if cell == nil {
                cell = HomeTableViewCell()
                cell?.identifier = HomeTableViewCell.identifire
            }
            cell?.setModel(model, tableColumn: tableColumn)
            cell?.textFieldChangeClosure = { [weak self] value in
                self?.updatValue(value, tableColumn: tableColumn, item: item)
            }
            return cell
        }
    }
    
}
