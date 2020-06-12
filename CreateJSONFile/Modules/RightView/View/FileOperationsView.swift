//
//  fileOperationsView.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

enum FileOperationsButtomType {
    case generate // 生成
    case validation // 验证
    case check // 切换
    case obtain // 获取数据
}

protocol FileOperationsDelegate: class {
    func fileOperationsSelect(_ view: FileOperationsView, type: FileOperationsButtomType)
    
    func fileOperationsView(_ view: FileOperationsView, json: JSON)
}

extension FileOperationsDelegate {
    func fileOperationsSelect(_ view: FileOperationsView, type: FileOperationsButtomType) { }
}

protocol FileOperationsDataSource: class {
    // 获取header
    func fileOperationsGetHeader(_ view: FileOperationsView) -> Dictionary<String, String>
    // 获取body
    func fileOperationsGetBody(_ view: FileOperationsView) -> Dictionary<String, Any>
    // 获取params
    func fileOperationsGetParams(_ view: FileOperationsView) -> Dictionary<String, Any>
    // 获取格式化数据
    func fileOperationGetModel(_ view: FileOperationsView) -> [HomeContentModel]
    // 获取json字符串
    func fileOperationGetJsonStr(_ view: FileOperationsView) -> String
    
}

extension FileOperationsDataSource {
    func fileOperationsGetHeader(_ view: FileOperationsView) -> Dictionary<String, String> {
        return [String: String]()
    }
    func fileOperationsGetBody(_ view: FileOperationsView) -> Dictionary<String, Any> {
        return [String: Any]()
    }
    func fileOperationsGetParams(_ view: FileOperationsView) -> Dictionary<String, Any> {
        return [String: Any]()
    }
    func fileOperationGetModel(_ view: FileOperationsView) -> [HomeContentModel] {
        return []
    }

    func fileOperationGetJsonStr(_ view: FileOperationsView) -> String {
        return ""
    }
    
}

class FileOperationsView: NSView {
    
//    override var isFlipped: Bool {
//        return true
//    }
    
    public weak var delegate: FileOperationsDelegate?
    
    public weak var dataSource: FileOperationsDataSource?
    
    public lazy var projectNameTextField: NSTextField = {
        let textField = NSTextField()
        textField.placeholderString = "请输入项目名称"
        textField.isBordered = true
        textField.layer?.cornerRadius = 3
        textField.delegate = self
        return textField
    }()
    
    public lazy var urlTextField: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.placeholderString = "请输入url地址获取数据"
        textField.isBordered = true
        textField.focusRingType = .none
        textField.stringValue = "https://api.apiopen.top/musicRankings"
        textField.usesSingleLineMode = true
        return textField
    }()
    
    fileprivate lazy var generateButton: NSButton = {
        let button = NSButton(title: "生成", target: self, action: #selector(generateButtonClick(_ :)))
        return button
    }()
    
    fileprivate lazy var validationButton: NSButton = {
        let button = NSButton(title: "验证", target: self, action: #selector(validationButtonClick))
        return button
    }()
    
    fileprivate lazy var dataButton: NSButton = {
        let button = NSButton(title: "获取数据", target: self, action: #selector(dataButtonClick))
        return button
    }()
    
    fileprivate lazy var addButton: NSButton = {
        let button = NSButton(title: "添加", target: self, action: #selector(addButtonClick(_ :)))
        return button
    }()
    
    fileprivate lazy var homePopVC: PopViewController = {
        return PopViewController()
    }()
    
    fileprivate lazy var popover: NSPopover = {
        let pop = NSPopover()
        pop.contentSize = NSSize(width: 600, height: 300)
        pop.contentViewController = homePopVC
        pop.behavior = .transient
        pop.animates = true
        pop.appearance = NSAppearance(named: NSAppearance.Name.aqua)
        return pop
    }()
    
    public lazy var checkButton: NSPopUpButton = {
        let button = NSPopUpButton()
        button.removeAllItems()
        button.addItems(withTitles: ["POST", "GET"])
        return button
    }()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- initView
    fileprivate func initView() {
        addSubview(projectNameTextField)
        addSubview(checkButton)
        addSubview(urlTextField)
        addSubview(dataButton)
        addSubview(generateButton)
        addSubview(validationButton)
        
//        checkButton.selectItem(at: 0)
        checkButton.target = self
        checkButton.action = #selector(checkButtonSelect(_:))
        
        projectNameTextField.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(25)
            $0.width.equalTo(120)
            $0.top.equalTo(15)
        }
        
        checkButton.snp.makeConstraints {
            $0.top.equalTo(projectNameTextField.snp.bottom).offset(10)
            $0.width.equalTo(80)
            $0.left.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        urlTextField.snp.makeConstraints {
            $0.right.equalTo(-95)
            $0.centerY.equalTo(checkButton)
            $0.left.equalTo(checkButton.snp.right).offset(5)
            $0.height.equalTo(25)
        }
        
        dataButton.snp.makeConstraints {
            $0.centerY.equalTo(checkButton)
            $0.width.equalTo(80)
            $0.right.equalToSuperview()
        }
        
        generateButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(projectNameTextField)
            $0.width.equalTo(67)
        }

        validationButton.snp.makeConstraints {
            $0.centerY.equalTo(projectNameTextField)
            $0.width.equalTo(67)
            $0.right.equalTo(generateButton.snp.left).offset(-10)
        }

    }
    
    // MARK:- objc
    @objc fileprivate func checkButtonSelect(_ sender: NSPopUpButton) {
        checkButton.title = sender.selectedItem?.title ?? ""
    }
    
    
    @objc fileprivate func generateButtonClick(_ sender: NSButton) {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "JSONModel"
        panel.allowedFileTypes = ["swift"]
        guard let showWindow = self.window else { return }
        panel.beginSheetModal(for: showWindow) { (response) in
            if response == .OK {
                guard let model = self.dataSource?.fileOperationGetModel(self), let url = panel.directoryURL else {
                    return
                }
                let folderUrl = url.appendingPathComponent(Date().formattingDate()).appendingPathComponent("\(panel.nameFieldStringValue).swift")
                let contentModel = HomeDataSource(inheritanceStr: "HandyJSON", contentArr: model, fileName: panel.nameFieldStringValue, productName: self.projectNameTextField.stringValue)
                FileDataModel.createFileSwift(folderUrl, homeData: contentModel) { (successFul) in
                    print(successFul)
                }
            }
        }
    }

    
    @objc fileprivate func validationButtonClick() {
        let str = dataSource?.fileOperationGetJsonStr(self) ?? ""
        let json = JSON(parseJSON: str)
        if json.isEmpty {
            alertError("请输入正确的json字符串")
        }else {
            delegate?.fileOperationsView(self, json: json)
        }
    }
    
    @objc fileprivate func dataButtonClick() {
        let url1 = urlTextField.stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        guard let url = URL(string: url1) else {
            alertError("请输入正确URL地址")
            return
        }
        guard let method = HTTPMethod(rawValue: checkButton.title) else {
            alertError("添加请求方式")
            return
        }
        let headers = dataSource?.fileOperationsGetHeader(self) ?? [String: String]()
        let params = dataSource?.fileOperationsGetParams(self) ?? [String: Any]()
        let body = dataSource?.fileOperationsGetBody(self) ?? [String: Any]()
        switch method {
        case .get:            
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                if let json = try? JSON(data: response.data ?? Data()) {
                    self.delegate?.fileOperationsView(self, json: json)
                }
            }
        default:
            Alamofire.request(url, method: method, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                if let json = try? JSON(data: response.data ?? Data()) {
                    self.delegate?.fileOperationsView(self, json: json)
                }
            }
            
        }

    }
    
    // json转data
    private func jsonToData(json: Any) -> Data? {
        if !JSONSerialization.isValidJSONObject(json) {
            print("is not a valid json object")
            return nil
        }
        //利用自带的json库转换成Data
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            print("is not a valid json object")
            return nil
        }
        // Data转换成String打印输出
        let str = String(data: data , encoding: String.Encoding.utf8)
        // 输出json字符串
        print("Json Str:\(str ?? "")")
        return data
    }
    
    @objc fileprivate func addButtonClick(_ sender: NSButton) {
        if popover.isShown {
            popover.performClose(sender)
        }else {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxX)
        }
    }
    
    
}

extension FileOperationsView: NSTextFieldDelegate {
    func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        return true
    }
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        return true
    }
}

