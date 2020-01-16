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
    
    fileprivate lazy var mainSplitView: MainSplitView = {
        let splitView = MainSplitView(frame: CGRect(x: 0, y: 50, width: self.view.width, height: self.view.height - 50))
        splitView.autoresizingMask = [.height, .width]
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.delegate = self
        return splitView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print(Date.dateWithStr(time: "2020-01-09T03:57:59.000+0000").formattingDate("yyyy-MM-dd HH:mm:ss"))
        initView()
    }
    
    // MARK:- initView
    fileprivate func initView() {
        
        let view1 = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: mainSplitView.height))
        view1.autoresizingMask = [.width, .height]
        view1.wantsLayer = true
        view1.layer?.backgroundColor = NSColor.randomColor.cgColor
        
        let rightView = MainRightView(frame: NSRect(x: 201, y: 0, width: mainSplitView.width - 201, height: mainSplitView.height))
        rightView.autoresizingMask = [.width, .height]
        
        mainSplitView.addArrangedSubview(view1)
        mainSplitView.addArrangedSubview(rightView)
        view.addSubview(mainSplitView)
        
        
    }
    
}
    


    
extension HomeViewController: NSSplitViewDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource {
        
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return 2
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return "1212"
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        return nil
       
    }
    
        
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
    
extension HomeViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }
    
}
    
    
    
    
    
    
    
    
    
//    // 关键字
//    fileprivate let appKeyword = APPKeyword()
//
//    fileprivate var homeData: HomeDataSource = HomeDataSource()
//
//
//    fileprivate lazy var topView: HomeTopView = {
//        let view = HomeTopView(frame: NSRect(x: 10, y: 10, width: self.view.width - 20, height: 100))
//        view.autoresizingMask = [.width]
//        view.delegate = self
//        return view
//    }()
//
//    fileprivate lazy var conetntScrollView: NSScrollView = {
//        let scroll = NSScrollView(frame: NSRect(x: 0, y: 0, width: self.view.width - 20, height: self.view.height/2))
//        scroll.autoresizingMask = .none
//        return scroll
//    }()
//
//    fileprivate lazy var textView: NSTextView = {
//        let textView = NSTextView(frame: self.conetntScrollView.bounds)
//        textView.autoresizingMask = [.width]
//        textView.isEditable = true
//        textView.textColor = NSColor.white
//        textView.insertionPointColor = NSColor.white
//        textView.textContainer?.widthTracksTextView = true
//        textView.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
//
//        return textView
//    }()
//
//
//    fileprivate lazy var scrollView: NSScrollView = {
//        let scroll = NSScrollView(frame: .zero)
//        scroll.autoresizingMask = .none
//        return scroll
//    }()
//
//
//    fileprivate lazy var outlineView: NSOutlineView = {
//        let outlineView = NSOutlineView()
//        outlineView.delegate = self
//        outlineView.dataSource = self
//        outlineView.focusRingType = .none
//        outlineView.selectionHighlightStyle = .none
//        outlineView.rowHeight = 38
//        outlineView.usesAlternatingRowBackgroundColors = true
//        return outlineView
//    }()
//
//    fileprivate lazy var popover: NSPopover = {
//        let pop = NSPopover()
//        pop.contentSize = NSSize(width: 600, height: 300)
//        pop.contentViewController = HomePopViewController()
//        pop.animates = true
//        pop.appearance = NSAppearance(named: NSAppearance.Name.aqua)
//        return pop
//    }()
//
//
////    override func loadView() {
////        let frame = NSApplication.shared.mainWindow?.frame
////        self.view = ContentView(frame: frame ?? NSRect.zero)
////    }
////
//
//
//
//    // MARK:- initView
//    fileprivate func initView() {
//        view.addSubview(topView)
//        conetntScrollView.documentView = textView
//        scrollView.documentView = outlineView
//
//        let splitView = NSSplitView(frame: NSRect(x: 10, y: topView.frame.maxY, width: view.width - 20, height: view.height - topView.frame.maxY))
//        splitView.autoresizingMask = [.width, .height]
//        splitView.dividerStyle = .thin
//        splitView.autoresizesSubviews = true
//
//        splitView.addSubview(conetntScrollView)
//        splitView.addSubview(scrollView)
//
//        view.addSubview(splitView)
//
//
//        let keyColumn = NSTableColumn(identifier: "keyColumn".identifire)
//        keyColumn.title = "key"
//        keyColumn.width = 100
//        keyColumn.minWidth = 100
//        outlineView.addTableColumn(keyColumn)
//
//        let stateColumn = NSTableColumn(identifier: "stateColumn".identifire)
//        stateColumn.title = "忽略"
//        stateColumn.width = 44
//        stateColumn.minWidth = 44
//        outlineView.addTableColumn(stateColumn)
//
//        let outputTypeColumn = NSTableColumn(identifier: "outputTypeColumn".identifire)
//        outputTypeColumn.title = "输出类型"
//        outputTypeColumn.width = 120
//        outputTypeColumn.minWidth = 120
//        outlineView.addTableColumn(outputTypeColumn)
//
//        let defaultColumn = NSTableColumn(identifier: "defaultColumn".identifire)
//        defaultColumn.title = "默认值"
//        defaultColumn.width = 100
//        defaultColumn.minWidth = 100
//        outlineView.addTableColumn(defaultColumn)
//
//        let annotationColumn = NSTableColumn(identifier: "annotationColumn".identifire)
//        annotationColumn.title = "注释"
//        annotationColumn.width = view.width - 388
//        annotationColumn.minWidth = 100
//        outlineView.addTableColumn(annotationColumn)
//    }
//
//}
//
//extension HomeViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
//    // 每一层级节点包含的下一级节点的数量。
//    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
//        if let model = item as? HomeContentModel {
//            return model.childArr.count
//        }else {
//            return homeData.contentArr.count
//        }
//    }
//
//    // 每一层级节点的模型对象为item时,根据item获取子节点模型。item为nil空时表示获取顶级节点模型。
//    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
//        if let model = item as? HomeContentModel {
//            return model.childArr[index]
//        }else {
//            return homeData.contentArr[index]
//        }
//    }
//
//    // 节点是否可以打开
//    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
//        if let model = item as? HomeContentModel {
//            return model.childArr.count > 0
//        }else {
//            return homeData.contentArr.count > 0
//        }
//    }
//
//    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
//        guard let model = item as? HomeContentModel else { return nil }
//
//        if tableColumn?.identifier == "stateColumn".identifire {
//            var cell = outlineView.makeView(withIdentifier: HomeIgnoreTableViewCell.identifire, owner: self) as? HomeIgnoreTableViewCell
//            if cell == nil {
//                cell = HomeIgnoreTableViewCell()
//                cell?.identifier = HomeIgnoreTableViewCell.identifire
//            }
//            cell?.checkButton.state = model.isIgnore ? .on : .off
//            cell?.didSelectClosure = {
//                model.isIgnore = !model.isIgnore
//            }
//            return cell
//        }
//        if tableColumn?.identifier == "outputTypeColumn".identifire {
//            var cell = outlineView.makeView(withIdentifier: HomeTypeTableCellView.identifire, owner: self) as? HomeTypeTableCellView
//            if cell == nil {
//                cell = HomeTypeTableCellView()
//                cell?.identifier = HomeTypeTableCellView.identifire
//            }
//            cell?.checkButton.selectItem(withTitle: model.outputType.outputStr)
//            switch model.outputType {
//            case .array(_), .dictionary(_):
//                cell?.checkButton.isEnabled = false
//            default:
//                cell?.checkButton.isEnabled = true
//            }
//            return cell
//        }
//        var cell = outlineView.makeView(withIdentifier: HomeTableViewCell.identifire, owner: self) as? HomeTableViewCell
//        if cell == nil {
//            cell = HomeTableViewCell()
//            cell?.identifier = HomeTableViewCell.identifire
//        }
//        cell?.textFieldChangeClosure = { string in
//            if tableColumn?.identifier == "defaultColumn".identifire {
//                model.defaultStr = string
//            }else if tableColumn?.identifier == "annotationColumn".identifire {
//                model.annotation = string
//            }
//        }


//        if tableColumn?.identifier == "keyColumn".identifire {
//            cell?.nameTextField.isEditable = false
//            cell?.nameTextField.stringValue = model.key
//        }else if tableColumn?.identifier == "defaultColumn".identifire {
//            switch model.outputType {
//            case .array(_), .dictionary(_):
//                cell?.nameTextField.isEditable = false
//                cell?.nameTextField.stringValue = ""
//                cell?.nameTextField.placeholderString = model.defaultStr
//            default:
//                cell?.nameTextField.isEditable = true
//                cell?.nameTextField.stringValue = model.defaultStr
//                cell?.nameTextField.placeholderString = "默认值"
//            }
//        }else {
//            cell?.nameTextField.isEditable = true
//            cell?.nameTextField.stringValue = model.annotation
//            cell?.nameTextField.placeholderString = "注释"
//        }
//        return cell
//    }
//
//
//}
//
//
//extension HomeViewController: HomeTopViewDelegate {
//    func homeTopView(_ view: HomeTopView, json: JSON) {
//        textView.string = json.description
//        guard let dic = json.dictionaryObject else { return }
//        homeData.contentArr = HomeDataModel.formattingJSON(dic)
//        outlineView.reloadData()
//    }
//
//    func homeTopSelect(_ view: HomeTopView, type: HomeTopButtomType) {
//        switch type {
//        case .generate:
//            let fileName = view.fileNameTextField.stringValue.pregReplace(pattern: "[. ]", with: "")
//            let authorName = view.authorTextField.stringValue.pregReplace(pattern: "[. ]", with: "")
//            let projectName = view.projectNameTextField.stringValue.pregReplace(pattern: "[. ]", with: "")
//            if !projectName.isEmpty { homeData.fileHeaderArr[2] = "\(appKeyword.annotationStr)\(projectName)" }
//            if !fileName.isEmpty && !authorName.isEmpty && !textView.string.isEmpty {
//                homeData.fileHeaderArr[1] = "\(appKeyword.annotationStr)\(fileName).swift"
//                homeData.fileHeaderArr[4] = "\(appKeyword.annotationStr)Created by \(authorName) on \(Date().formattingDate(Date.dateFormatSlashDay))."
//                guard let dict = JSON(parseJSON: textView.string).dictionaryObject else {
//                    view.alertError("请输入正确的JSON数据")
//                    return
//                }
//                textView.string = JSON(parseJSON: textView.string).description
//                homeData.jsonDic = dict
//                if homeData.contentArr.count == 0 {
//                    homeData.contentArr = HomeDataModel.formattingJSON(dict)
//                }
//                homeData.inheritanceStr = view.checkButton.selectedItem?.title ?? ""
//                homeData.structName = fileName
//                HomeDataModel.createFileSwift(fileName, homeData: homeData) { (success) in
//                    if !success { view.alertError("创建文件失败") }
//                }
//            }else {
//                if fileName.isEmpty {
//                    view.alertError("请输入文件名称")
//                }else if authorName.isEmpty {
//                    view.alertError("请输入作者名称")
//                }else if textView.string.isEmpty {
//                    view.alertError("请输入JSON数据")
//                }
//            }
//        case .validation:
//            guard let dict = JSON(parseJSON: textView.string).dictionaryObject else {
//                view.alertError("请输入正确的JSON数据")
//                return
//            }
//            textView.string = JSON(parseJSON: textView.string).description
//            homeData.contentArr = HomeDataModel.formattingJSON(dict)
//            outlineView.reloadData()
//        case .check:
//            let pop = NSPopover()
//            let homeVC = ViewController()
//            pop.contentSize = NSSize(width: 100, height: 200)
//            pop.contentViewController = homeVC
//            pop.animates = false
//            pop.appearance = NSAppearance(named: NSAppearance.Name.aqua)
//
//            if pop.isShown {
//                pop.performClose(view.checkButton)
//
//            }else {
//                let cell = view.checkButton.bounds
//                pop.show(relativeTo: cell, of: view.checkButton, preferredEdge: NSRectEdge.maxX)
//            }
//        case .obtain: break
//        }
//    }
//
//
//}

class ContentView: NSView {
    
    override var isFlipped: Bool {
        return true
    }
}
