//
//  HomePopViewController.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/6.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import Alamofire

class HomePopViewController: NSViewController {
    
    public lazy var methodTextField: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.isBordered = false
        textField.font = NSFont.systemFont(ofSize: 16)
        textField.backgroundColor = NSColor.clear
        textField.cell = BaseTextFieldCell()
        textField.stringValue = "Method"
        return textField
    }()
    
    public lazy var bodyTextField: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.isBordered = false
        textField.font = NSFont.systemFont(ofSize: 16)
        textField.backgroundColor = NSColor.clear
        textField.cell = BaseTextFieldCell()
        textField.stringValue = "BodyType"
        return textField
    }()
    
    public lazy var headerGinsengTextField: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.isBordered = false
        textField.font = NSFont.systemFont(ofSize: 16)
        textField.backgroundColor = NSColor.clear
        textField.cell = BaseTextFieldCell()
        textField.stringValue = "Header"
        return textField
    }()
    
    public lazy var bodyGinsengTextField: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.isBordered = false
        textField.font = NSFont.systemFont(ofSize: 16)
        textField.backgroundColor = NSColor.clear
        textField.cell = BaseTextFieldCell()
        textField.stringValue = "Body"
        return textField
    }()
    
    public lazy var checkButton: NSPopUpButton = {
        let button = NSPopUpButton()
        return button
    }()
    
    public lazy var bodyCheckButton: NSPopUpButton = {
        let button = NSPopUpButton()
        return button
    }()
    
    fileprivate lazy var scrollView: NSScrollView = {
        let scroll = NSScrollView(frame: NSRect(x: 0, y: 100, width: self.view.width/5*2, height: self.view.height - 100))
        scroll.autoresizingMask = .none
        return scroll
    }()
    
    
    fileprivate lazy var headerOutlineView: NSOutlineView = {
        let outlineView = NSOutlineView()
        return outlineView
    }()
    
    fileprivate lazy var contentScrollView: NSScrollView = {
        let scroll = NSScrollView(frame: NSRect(x: 0, y: 100, width: self.view.width/5*3, height: self.view.height - 100))
        scroll.autoresizingMask = .none
        return scroll
    }()
    
    
    fileprivate lazy var contentOutlineView: NSOutlineView = {
        let outlineView = NSOutlineView()
        return outlineView
    }()
    
    fileprivate lazy var splitView: NSSplitView = {
        let splitView = NSSplitView(frame: NSRect(x: 10, y: 80, width: self.view.width - 20, height: self.view.height - 100))
        splitView.autoresizingMask = [.width, .height]
        splitView.dividerStyle = .thick
        splitView.isVertical = true
        splitView.autoresizesSubviews = true
        return splitView
    }()
    
    fileprivate lazy var addButton: NSButton = {
        let button = NSButton(image: NSImage(named: NSImage.addTemplateName)!, target: self, action: #selector(addButtonClick))
        button.setButtonType(.momentaryPushIn)
        return button
    }()
    
    fileprivate lazy var reduceButton: NSButton = {
        let button = NSButton(image: NSImage(named: NSImage.removeTemplateName)!, target: self, action: #selector(reduceButtonClick))
        button.setButtonType(.momentaryPushIn)
        return button
    }()
    
    public lazy var headerArr: Array = [HomePopModel]()
    public lazy var contentArr: Array = [HomePopModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let homePopModel = HomePopModel(key: "params", value: "(0 items)", type: .dictionary(""), isEdit: false)
        contentArr.append(homePopModel)
        

//        contentArr[0].childArr.append(HomePopModel(key: "page", value: "1", type: .string))
//
//        contentArr[0].childArr.append(HomePopModel(key: "size", value: "10", type: .string))
//
//        contentArr[0].childArr.append(HomePopModel(key: "param", value: "didcaodas", type: .dictionary("")))

//        let ddd: NSSplitView
        
        
        initView()
    }
    
    override func loadView() {
        self.view = ContentView(frame: CGRect(x: 0, y: 0, width: 600, height: 300))
    }
    
    // MARK:- initView
    fileprivate func initView() {
        view.addSubview(methodTextField)
        view.addSubview(checkButton)
        view.addSubview(bodyTextField)
        view.addSubview(bodyCheckButton)
        setOutlineView(headerOutlineView)
        setOutlineView(contentOutlineView)
        scrollView.documentView = headerOutlineView
        contentScrollView.documentView = contentOutlineView
        splitView.addSubview(scrollView)
        splitView.addSubview(contentScrollView)
        addTableColumn()
        view.addSubview(splitView)
        view.addSubview(headerGinsengTextField)
        view.addSubview(bodyGinsengTextField)
        view.addSubview(addButton)
        view.addSubview(reduceButton)


        headerGinsengTextField.snp.makeConstraints {
            $0.left.equalTo(scrollView)
            $0.bottom.equalTo(scrollView.snp.top).offset(-10)
        }
        
        bodyGinsengTextField.snp.makeConstraints {
            $0.left.equalTo(contentScrollView)
            $0.bottom.equalTo(contentScrollView.snp.top).offset(-10)
        }
        
        methodTextField.snp.makeConstraints {
            $0.top.left.equalTo(15)
        }
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalTo(methodTextField)
            $0.width.equalTo(100)
            $0.left.equalTo(methodTextField.snp.right).offset(15)
        }
        
        bodyTextField.snp.makeConstraints {
            $0.centerY.equalTo(methodTextField)
            $0.left.equalTo(checkButton.snp.right).offset(45)
        }
        
        bodyCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(bodyTextField)
            $0.width.equalTo(80)
            $0.left.equalTo(bodyTextField.snp.right).offset(15)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(headerGinsengTextField)
            $0.height.equalTo(30)
            $0.right.equalTo(scrollView.snp.right)
        }
        
        reduceButton.snp.makeConstraints {
            $0.centerY.equalTo(headerGinsengTextField)
            $0.height.equalTo(30)
            $0.right.equalTo(addButton.snp.left)
        }
    }
    
    fileprivate func addTableColumn() {
        let keyColumn = NSTableColumn(identifier: "keyColumn".identifire)
         keyColumn.title = "key"
         keyColumn.width = 100
         keyColumn.minWidth = 100
         headerOutlineView.addTableColumn(keyColumn)
         
         let stateColumn = NSTableColumn(identifier: "valueColumn".identifire)
         stateColumn.title = "value"
         stateColumn.width = view.width/5*2-100
         stateColumn.minWidth = 100
         headerOutlineView.addTableColumn(stateColumn)
         
         let contentKeyColumn = NSTableColumn(identifier: "contentKeyColumn".identifire)
         contentKeyColumn.title = "key"
         contentKeyColumn.width = view.width/5
         contentKeyColumn.minWidth = 100
         contentOutlineView.addTableColumn(contentKeyColumn)
         
         let contentTypeColumn = NSTableColumn(identifier: "contentTypeColumn".identifire)
         contentTypeColumn.title = "type"
         contentTypeColumn.width = view.width/5 - 15
         contentTypeColumn.minWidth = 100
         contentOutlineView.addTableColumn(contentTypeColumn)
         
         let contentStateColumn = NSTableColumn(identifier: "contentStateColumn".identifire)
         contentStateColumn.title = "value"
         contentStateColumn.width = view.width/5 + 15
         contentStateColumn.minWidth = 100
         contentOutlineView.addTableColumn(contentStateColumn)
         
         checkButton.removeAllItems()
         bodyCheckButton.removeAllItems()
         checkButton.addItems(withTitles: [HTTPMethod.post.rawValue,HTTPMethod.get.rawValue,HTTPMethod.put.rawValue,HTTPMethod.delete.rawValue,HTTPMethod.options.rawValue,HTTPMethod.head.rawValue,HTTPMethod.patch.rawValue,HTTPMethod.trace.rawValue,HTTPMethod.connect.rawValue])
         bodyCheckButton.addItems(withTitles: ["Raw","JSON","From"])
    }
    
    fileprivate func setOutlineView(_ outlineView: NSOutlineView) {
        outlineView.delegate = self
        outlineView.dataSource = self
        outlineView.focusRingType = .none
        outlineView.selectionHighlightStyle = .regular
        outlineView.rowHeight = 30
        outlineView.usesAlternatingRowBackgroundColors = true
    }
    
    
    // MARK:- objc
    @objc fileprivate func addButtonClick() {
        headerArr.append(HomePopModel())
        headerOutlineView.reloadData()
    }
    
    @objc fileprivate func reduceButtonClick() {
        if headerOutlineView.selectedRow != -1 {
            headerArr.remove(at: headerOutlineView.selectedRow)
            headerOutlineView.reloadData()
        }
    }
}


extension HomePopViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    // 每一层级节点包含的下一级节点的数量。
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if outlineView == headerOutlineView {
            return headerArr.count
        }else {
            if let model = item as? HomePopModel {
                return model.childArr.count
            }else {
                return contentArr.count
            }
        }
    }

    // 每一层级节点的模型对象为item时,根据item获取子节点模型。item为nil空时表示获取顶级节点模型。
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if outlineView == headerOutlineView {
            return headerArr[index]
        }else {
            if let model = item as? HomePopModel {
                return model.childArr[index]
            }else {
                return contentArr[index]
            }
        }
    }

    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if outlineView == headerOutlineView {
            return false
        }else {
            if let model = item as? HomePopModel {
                switch model.type {
                case .array(_), .dictionary(_):
                    return true
                default:
                    return false
                }
            }else {
                return true
            }
        }
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let model = item as? HomePopModel else { return nil }

        if outlineView == headerOutlineView {
            var cell = outlineView.makeView(withIdentifier: HomeTableViewCell.identifire, owner: self) as? HomeTableViewCell
            if cell == nil {
                cell = HomeTableViewCell()
                cell?.identifier = HomeTableViewCell.identifire
            }
            cell?.nameTextField.placeholderString = "key"
            cell?.nameTextField.isEditable = true
            if tableColumn?.identifier == "keyColumn".identifire {
                cell?.nameTextField.placeholderString = "key"
                cell?.nameTextField.stringValue = model.key
            }else {
                cell?.nameTextField.placeholderString = "value"
                cell?.nameTextField.stringValue = model.value
            }
            cell?.textFieldChangeClosure = { str in
                if tableColumn?.identifier == "keyColumn".identifire {
                    model.key = str
                }else {
                    model.value = str
                }
            }
            return cell
        }else {
            if tableColumn?.identifier == "contentTypeColumn".identifire {
                var cell = outlineView.makeView(withIdentifier: HomeTypeTableCellView.identifire, owner: self) as? HomeTypeTableCellView
                if cell == nil {
                    cell = HomeTypeTableCellView()
                    cell?.identifier = HomeTypeTableCellView.identifire
                }
                cell?.checkButton.selectItem(withTitle: model.type.outputStr)
                cell?.checkButton.isEnabled = model.isEdit
                cell?.didSelectCheck = { [weak self] type in
                    model.type = type
                    model.childArr.removeAll()
                    self?.contentOutlineView.reloadData()
                }
                return cell
            }
            var cell = outlineView.makeView(withIdentifier: HomeTableViewCell.identifire, owner: self) as? HomeTableViewCell
            if cell == nil {
                cell = HomeTableViewCell()
                cell?.identifier = HomeTableViewCell.identifire
            }
            cell?.nameTextField.isEditable = model.isEdit
            cell?.isRoot = !model.isEdit
            cell?.nameTextField.stringValue = ""
            if !model.isEdit {
                if tableColumn?.identifier == "contentKeyColumn".identifire {
                    cell?.nameTextField.placeholderString = model.key
                }else {
                    cell?.nameTextField.placeholderString = model.value
                    cell?.isMouse = true
                }
            }else {
                if tableColumn?.identifier == "contentKeyColumn".identifire {
                    cell?.nameTextField.placeholderString = "key"
                    cell?.nameTextField.stringValue = model.key
                }else {
                    cell?.isMouse = true
                    switch model.type {
                    case .array(_), .dictionary(_):
                        cell?.nameTextField.isEditable = false
                        cell?.nameTextField.placeholderString = "(\(model.childArr.count) items)"
                    default:
                        cell?.nameTextField.placeholderString = "value"
                        cell?.nameTextField.stringValue = model.value
                    }
                }
            }
            cell?.didSelectButtonClosure = { [weak self] state in
                if state {
                    switch model.type {
                    case .array(""), .dictionary(""):
                        let popModel = HomePopModel()
                        model.childArr.append(popModel)
                        self?.contentOutlineView.reloadData()
                    default:
                        if let parentModel = outlineView.parent(forItem: item) as? HomePopModel {
                            let popModel = HomePopModel()
                            parentModel.childArr.append(popModel)
                            self?.contentOutlineView.reloadData()
                        }
                    }
                }else {
                    if let parentModel = outlineView.parent(forItem: item) as? HomePopModel {
                        parentModel.childArr.remove(at: outlineView.childIndex(forItem: item))
                        self?.contentOutlineView.reloadData()
                    }
                }
            }
            
            cell?.textFieldChangeClosure = { str in
                if tableColumn?.identifier == "contentKeyColumn".identifire {
                    model.key = str
                }else {
                    model.value = str
                }
            }
            return cell
        }
    }
}
