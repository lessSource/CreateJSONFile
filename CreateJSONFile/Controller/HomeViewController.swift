//
//  HomeViewController.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import SwiftyJSON

class HomeViewController: NSViewController {
    // 关键字
    fileprivate let appKeyword = APPKeyword()
    
    fileprivate var homeData: HomeDataSource = HomeDataSource()
    
    
    fileprivate lazy var topView: HomeTopView = {
        let view = HomeTopView(frame: NSRect(x: 10, y: 10, width: self.view.width - 20, height: 50))
        view.autoresizingMask = [.width]
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var conetntScrollView: NSScrollView = {
        let scroll = NSScrollView(frame: .zero)
        scroll.autoresizingMask = .none
        return scroll
    }()
    
    fileprivate lazy var textView: NSTextView = {
        let textView = NSTextView(frame: self.conetntScrollView.bounds)
        textView.autoresizingMask = [.width]
        textView.isEditable = true
        textView.textColor = NSColor.white
        textView.insertionPointColor = NSColor.white
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        return textView
    }()
    
    
    fileprivate lazy var scrollView: NSScrollView = {
        let scroll = NSScrollView(frame: .zero)
        scroll.autoresizingMask = .none
        return scroll
    }()
    
    
    fileprivate lazy var outlineView: NSOutlineView = {
        let outlineView = NSOutlineView()
        outlineView.delegate = self
        outlineView.dataSource = self
        outlineView.focusRingType = .none
        outlineView.selectionHighlightStyle = .none
        outlineView.rowHeight = 38
        outlineView.usesAlternatingRowBackgroundColors = true
        return outlineView
    }()
    
    
    override func loadView() {
        let frame = NSApplication.shared.mainWindow?.frame
        self.view = ContentView(frame: frame ?? NSRect.zero)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initView()
        
        
    }
    
    // MARK:- initView
    fileprivate func initView() {
        view.addSubview(topView)
        conetntScrollView.documentView = textView
        scrollView.documentView = outlineView
        
        let splitView = NSSplitView(frame: NSRect(x: 10, y: topView.frame.maxY, width: view.width - 20, height: view.height - topView.frame.maxY))
        splitView.autoresizingMask = [.width, .height]
        splitView.dividerStyle = .thin
        splitView.autoresizesSubviews = true
        
        splitView.addSubview(conetntScrollView)
        splitView.addSubview(scrollView)
        
        view.addSubview(splitView)
        
        
        let keyColumn = NSTableColumn(identifier: "keyColumn".identifire)
        keyColumn.title = "key"
        keyColumn.width = 100
        keyColumn.minWidth = 100
        outlineView.addTableColumn(keyColumn)
        
        let stateColumn = NSTableColumn(identifier: "stateColumn".identifire)
        stateColumn.title = "忽略"
        stateColumn.width = 44
        stateColumn.minWidth = 44
        outlineView.addTableColumn(stateColumn)
        
        let outputTypeColumn = NSTableColumn(identifier: "outputTypeColumn".identifire)
        outputTypeColumn.title = "输出类型"
        outputTypeColumn.width = 120
        outputTypeColumn.minWidth = 120
        outlineView.addTableColumn(outputTypeColumn)
        
        let defaultColumn = NSTableColumn(identifier: "defaultColumn".identifire)
        defaultColumn.title = "默认值"
        defaultColumn.width = 100
        defaultColumn.minWidth = 100
        outlineView.addTableColumn(defaultColumn)
        
        let annotationColumn = NSTableColumn(identifier: "annotationColumn".identifire)
        annotationColumn.title = "注释"
        annotationColumn.width = view.width - 388
        annotationColumn.minWidth = 100
        outlineView.addTableColumn(annotationColumn)
    }
    
}

extension HomeViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    // 每一层级节点包含的下一级节点的数量。
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let model = item as? HomeContentModel {
            return model.childArr.count
        }else {
            return homeData.contentArr.count
        }
    }
    
    // 每一层级节点的模型对象为item时,根据item获取子节点模型。item为nil空时表示获取顶级节点模型。
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let model = item as? HomeContentModel {
            return model.childArr[index]
        }else {
            return homeData.contentArr[index]
        }
    }
    
    // 节点是否可以打开
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let model = item as? HomeContentModel {
            return model.childArr.count > 0
        }else {
            return homeData.contentArr.count > 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let model = item as? HomeContentModel else { return nil }
        
        if tableColumn?.identifier == "stateColumn".identifire {
            var cell = outlineView.makeView(withIdentifier: HomeIgnoreTableViewCell.identifire, owner: self) as? HomeIgnoreTableViewCell
            if cell == nil {
                cell = HomeIgnoreTableViewCell()
                cell?.identifier = HomeIgnoreTableViewCell.identifire
            }
            cell?.checkButton.state = model.isIgnore ? .on : .off
            
            cell?.didSelectClosure = { [weak self] in
                
                self?.test(outlineView, item: item)
//                // 当前层级序号
//                let childIndex = outlineView.childIndex(forItem: item)
//                let row = outlineView.row(forItem: item)
//                // 当前层级
//                let item = outlineView.level(forItem: item)
//                let level = outlineView.level(forRow: row)
//
////                outlineView.item(atRow: <#T##Int#>)
//                print([childIndex, item, row, level])
            }
            
//            let row = outlineView.selectedRow
//            let row1 = outlineView.row(forItem: <#T##Any?#>)
            
            return cell
        }
        if tableColumn?.identifier == "outputTypeColumn".identifire {
            var cell = outlineView.makeView(withIdentifier: HomeTypeTableCellView.identifire, owner: self) as? HomeTypeTableCellView
            if cell == nil {
                cell = HomeTypeTableCellView()
                cell?.identifier = HomeTypeTableCellView.identifire
            }
            cell?.checkButton.selectItem(withTitle: model.outputType.valueStr)
            cell?.checkButton.isEnabled = !(model.outputType == .array || model.outputType == .dictionary)
            return cell
        }
        var cell = outlineView.makeView(withIdentifier: HomeTableViewCell.identifire, owner: self) as? HomeTableViewCell
        if cell == nil {
            cell = HomeTableViewCell()
            cell?.identifier = HomeTableViewCell.identifire
        }
        if tableColumn?.identifier == "keyColumn".identifire {
            cell?.nameTextField.isEditable = false
            cell?.nameTextField.stringValue = model.key
        }else if tableColumn?.identifier == "defaultColumn".identifire {
            cell?.nameTextField.isEditable = true
            cell?.nameTextField.stringValue = model.defaultStr
            cell?.nameTextField.placeholderString = "默认值"
        }else {
            cell?.nameTextField.isEditable = true
            cell?.nameTextField.stringValue = model.annotation
            cell?.nameTextField.placeholderString = "注释"
        }
        return cell
    }
    
    fileprivate func test(_ outlineView: NSOutlineView, item: Any) {
        var array : Array = [Int]()
//        let childIndex = outlineView.childIndex(forItem: item)
        
        var any: Any? = item
        while any != nil {
            let index = outlineView.childIndex(forItem: any!)
            array.append(index)
            any = outlineView.parent(forItem: any)
        }
        
        print(array)
    }
    
    
    
}


extension HomeViewController: HomeTopViewDelegate {
    func homeTopSelect(_ view: HomeTopView, type: HomeTopButtomType) {
        switch type {
        case .generate:
            let fileName = view.fileNameTextField.stringValue.pregReplace(pattern: "[. ]", with: "")
            let authorName = view.authorTextField.stringValue.pregReplace(pattern: "[. ]", with: "")
            let projectName = view.projectNameTextField.stringValue.pregReplace(pattern: "[. ]", with: "")
            if !projectName.isEmpty { homeData.fileHeaderArr[2] = "\(appKeyword.annotationStr)\(projectName)" }
            if !fileName.isEmpty && !authorName.isEmpty && !textView.string.isEmpty {
                homeData.fileHeaderArr[1] = "\(appKeyword.annotationStr)\(fileName).swift"
                homeData.fileHeaderArr[4] = "\(appKeyword.annotationStr)Created by \(authorName) on \(Date().formattingDate(Date.dateFormatSlashDay))."
                guard let dict = JSON(parseJSON: textView.string).dictionaryObject else {
                    view.alertError("请输入正确的JSON数据")
                    return
                }
                textView.string = JSON(parseJSON: textView.string).description
                homeData.jsonDic = dict
                homeData.contentArr = HomeDataModel.formattingJSON(dict)
                homeData.inheritanceStr = view.checkButton.selectedItem?.title ?? ""
                homeData.structName = fileName
                HomeDataModel.createFileSwift(fileName, homeData: homeData) { (success) in
                    if !success { view.alertError("创建文件失败") }
                }
            }else {
                if fileName.isEmpty {
                    view.alertError("请输入文件名称")
                }else if authorName.isEmpty {
                    view.alertError("请输入作者名称")
                }else if textView.string.isEmpty {
                    view.alertError("请输入JSON数据")
                }
            }
        case .validation:
            guard let dict = JSON(parseJSON: textView.string).dictionaryObject else {
                view.alertError("请输入正确的JSON数据")
                return
            }
            textView.string = JSON(parseJSON: textView.string).description
            homeData.contentArr = HomeDataModel.formattingJSON(dict)
            outlineView.reloadData()
        case .check: break
            
        }
    }
    
    
}

class ContentView: NSView {
    
    override var isFlipped: Bool {
        return true
    }
}
