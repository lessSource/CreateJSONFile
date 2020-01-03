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
    
    fileprivate lazy var scrollView: NSScrollView = NSScrollView()
    
    fileprivate lazy var conetntScrollView: NSScrollView = NSScrollView()
    
    fileprivate lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.focusRingType = .none
        tableView.selectionHighlightStyle = .none
        tableView.rowHeight = 44
        
        return tableView
    }()
    
    fileprivate lazy var textView: NSTextView = {
        let textView = NSTextView()
        textView.autoresizingMask = .height
        textView.isEditable = true
        textView.textColor = NSColor.white
        textView.insertionPointColor = NSColor.white
        return textView
    }()
    
    fileprivate lazy var topView: HomeTopView = {
        let view = HomeTopView()
        view.delegate = self
        return view
    }()
    
    override func loadView() {
        let frame = NSApplication.shared.mainWindow?.frame
        self.view = NSView(frame: frame ?? NSRect.zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initView()
    }
    
    // MARK:- initView
    fileprivate func initView() {
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.left.top.equalTo(10)
            $0.right.equalTo(-10)
            $0.height.equalTo(50)
        }
        
        let keyColumn = NSTableColumn(identifier: "keyColumn".identifire)
        keyColumn.title = "key"
        keyColumn.width = 100
        keyColumn.minWidth = 100
        tableView.addTableColumn(keyColumn)
        
        let stateColumn = NSTableColumn(identifier: "stateColumn".identifire)
        stateColumn.title = "忽略"
        stateColumn.width = 44
        stateColumn.minWidth = 44
        tableView.addTableColumn(stateColumn)
        
        let outputTypeColumn = NSTableColumn(identifier: "outputTypeColumn".identifire)
        outputTypeColumn.title = "输出类型"
        outputTypeColumn.width = 120
        outputTypeColumn.minWidth = 120
        tableView.addTableColumn(outputTypeColumn)
        
        let defaultColumn = NSTableColumn(identifier: "defaultColumn".identifire)
        defaultColumn.title = "默认值"
        defaultColumn.width = 100
        defaultColumn.minWidth = 100
        tableView.addTableColumn(defaultColumn)

        let annotationColumn = NSTableColumn(identifier: "annotationColumn".identifire)
        annotationColumn.title = "注释"
        annotationColumn.width = 100
        annotationColumn.minWidth = 100
        tableView.addTableColumn(annotationColumn)
        
        scrollView.documentView = tableView
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(NSEdgeInsets(top: 350, left: 10, bottom: 10, right: 10))
        }
        
        conetntScrollView.documentView = textView
        view.addSubview(conetntScrollView)
        conetntScrollView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.bottom.equalTo(scrollView.snp.top)
        }
        textView.snp.makeConstraints {
            $0.edges.equalTo(conetntScrollView)
        }
    }
    
}

extension HomeViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 50
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.identifier == "stateColumn".identifire {
            var cell = tableView.makeView(withIdentifier: HomeIgnoreTableViewCell.identifire, owner: self) as? HomeIgnoreTableViewCell
            if cell == nil {
                cell = HomeIgnoreTableViewCell()
                cell?.identifier = HomeIgnoreTableViewCell.identifire
            }
            return cell
        }
        if tableColumn?.identifier == "outputTypeColumn".identifire {
            var cell = tableView.makeView(withIdentifier: HomeTypeTableCellView.identifire, owner: self) as? HomeTypeTableCellView
            if cell == nil {
                cell = HomeTypeTableCellView()
                cell?.identifier = HomeTypeTableCellView.identifire
            }
            return cell
        }
        
        var cell = tableView.makeView(withIdentifier: HomeTableViewCell.identifire, owner: self) as? HomeTableViewCell
        if cell == nil {
            cell = HomeTableViewCell()
            cell?.identifier = HomeTableViewCell.identifire
        }
        return cell
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
                print(dict)
                textView.string = JSON(parseJSON: textView.string).description
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
            print(dict)
            
        case .check: break
            
        }
    }
    
    
}
