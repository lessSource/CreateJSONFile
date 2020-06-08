//
//  HomeTopView.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

enum HomeTopButtomType {
    case generate // 生成
    case validation // 验证
    case check // 切换
    case obtain // 获取数据
    
}

protocol HomeTopViewDelegate: class {
    func homeTopSelect(_ view: FileOperationsView, type: HomeTopButtomType)
    
    func homeTopView(_ view: FileOperationsView, json: JSON)
}

class FileOperationsView: NSView {
    
//    override var isFlipped: Bool {
//        return true
//    }
    
    public weak var delegate: HomeTopViewDelegate?
    
    public lazy var fileNameTextField: NSTextField = {
        let textField = NSTextField()
        textField.placeholderString = "请输入文件名称"
        textField.isBordered = true
        return textField
    }()
    
    public lazy var authorTextField: NSTextField = {
        let textField = NSTextField()
        textField.placeholderString = "请输入作者"
        textField.isBordered = true
        textField.alignment = .right
        return textField
    }()
    
    public lazy var projectNameTextField: NSTextField = {
        let textField = NSTextField()
        textField.placeholderString = "请输入项目名称"
        textField.isBordered = true
        textField.alignment = .right
//        textField.cell = TestTextFieldCell()
//        textField.
        return textField
    }()
    
    public lazy var urlTextField: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.placeholderString = "请输入url地址获取数据"
        textField.isBordered = true
//        textField.focusRingType = .none
        textField.font = NSFont.systemFont(ofSize: 14)
        textField.delegate = self
//        textField.cell = BaseTextFieldCell()
//        textField.usesSingleLineMode = true
        return textField
    }()
    
    fileprivate lazy var generateButton: NSButton = {
        let button = NSButton(title: "生成", target: self, action: #selector(generateButtonClick))
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
        pop.animates = true
        pop.appearance = NSAppearance(named: NSAppearance.Name.aqua)
        return pop
    }()
    
    public lazy var checkButton: NSPopUpButton = {
        let button = NSPopUpButton()
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
        addSubview(fileNameTextField)
        addSubview(authorTextField)
        addSubview(projectNameTextField)
        addSubview(checkButton)
        addSubview(generateButton)
        addSubview(validationButton)
        addSubview(dataButton)
        addSubview(addButton)
        addSubview(urlTextField)
        
//        urlTextField.cell = TestTextFieldCell()

        
        fileNameTextField.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(25)
            $0.width.equalTo(120)
            $0.top.equalTo(15)
        }
        
        checkButton.removeAllItems()
        checkButton.addItems(withTitles: ["HandyJSON","NSObject"])
        checkButton.selectItem(at: 0)
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalTo(fileNameTextField)
            $0.width.equalTo(110)
            $0.left.equalTo(fileNameTextField.snp.right).offset(10)
        }
        
        generateButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(fileNameTextField)
            $0.width.equalTo(67)
        }
        
        validationButton.snp.makeConstraints {
            $0.centerY.equalTo(fileNameTextField)
            $0.width.equalTo(67)
            $0.right.equalTo(generateButton.snp.left).offset(-10)
        }
        
        authorTextField.snp.makeConstraints {
            $0.centerY.equalTo(fileNameTextField)
            $0.height.equalTo(25)
            $0.width.equalTo(80)
            $0.right.equalTo(validationButton.snp.left).offset(-10)
        }
        
        projectNameTextField.snp.makeConstraints {
            $0.centerY.equalTo(fileNameTextField)
            $0.height.equalTo(25)
            $0.width.equalTo(120)
            $0.right.equalTo(authorTextField.snp.left).offset(-10)
        }
        
        dataButton.snp.makeConstraints {
            $0.top.equalTo(validationButton.snp.bottom).offset(18)
            $0.width.equalTo(80)
            $0.right.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(dataButton)
            $0.width.equalTo(50)
            $0.right.equalTo(dataButton.snp.left).offset(-5)
        }
        
        urlTextField.snp.makeConstraints {
            $0.right.equalTo(addButton.snp.left).offset(-5)
            $0.centerY.equalTo(dataButton)
            $0.left.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    // MARK:- objc
    @objc fileprivate func generateButtonClick() {
        delegate?.homeTopSelect(self, type: .generate)
    }
    
    @objc fileprivate func validationButtonClick() {
        delegate?.homeTopSelect(self, type: .validation)
        print("validationButtonClick")
    }
    
    @objc fileprivate func dataButtonClick() {
        guard let url = URL(string: urlTextField.stringValue) else {
            alertError("请输入正确URL地址")
            return
        }
        
        let headers = HomePopDataModel.getHeaderDictionArray(homePopVC.headerArr)
        var params: Dictionary<String, Any> = [:]
        if homePopVC.contentArr.count > 0 {
            params = HomePopDataModel.getContentDictionArray(homePopVC.contentArr[0])
        }
        guard let method = HTTPMethod(rawValue: homePopVC.checkButton.title) else {
            alertError("添加请求方式")
            return
        }
        
        switch method {
        case .get:
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                if let json = try? JSON(data: response.data ?? Data()) {
                    self.delegate?.homeTopView(self, json: json)
                }
            }
        default:
            Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                if let json = try? JSON(data: response.data ?? Data()) {
                    self.delegate?.homeTopView(self, json: json)
                }
            }
        }
        
        //        let header1 = HomePopModel(key: "Content-type", value: "application/json")
        //        let header2 = HomePopModel(key: "token", value: "8ed436330a9a4cf8acfe4e286c0cc8eb")
        //        let headerModel =
        
//        params.updateValue("测试", forKey: "keyword")
//        params.updateValue(10, forKey: "size")
//        let param: Dictionary = [String: Any]()
//        params.updateValue(param, forKey: "param")
        
//        http://gateway.test.cef0e73c879624990a12fcf7c3cd3ea9d.cn-shanghai.alicontainer.com/salesman/storage/stock/info/ecs/list
//        http://gateway.test.cef0e73c879624990a12fcf7c3cd3ea9d.cn-shanghai.alicontainer.com/salesman/storage/transfer/selectSimpleGoods
//        http://gateway.test.cef0e73c879624990a12fcf7c3cd3ea9d.cn-shanghai.alicontainer.com/salesman/search/getShopCity

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

class TestTextFieldCell: NSTextFieldCell {
    
//    override init(textCell string: String) {
//        super.init(textCell: string)
//    }
//
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    required init(coder: NSCoder) {
//        super.init(coder: coder)
//
////        .vCentr
//    }
    
    
    fileprivate func adjustedFrameToVerticallyCenterText(frame: NSRect) -> NSRect {
//        let fontSize = font?.boundingRectForFont.size.height ?? 0
//        let offset = floor(NSHeight(frame) - ceil(fontSize)/2) - 5
//        let offset = NSHeight(frame)/2 - ((font?.ascender ?? 0) + (font?.descender ?? 0))
        
        var titleRect = super.titleRect(forBounds: frame)

        let minimumHeight = self.cellSize(forBounds: frame).height
        titleRect.origin.y += (titleRect.height - minimumHeight)/2
        titleRect.size.height = minimumHeight
        return titleRect

//        return NSInsetRect(frame, 0.0, offset)
    }


    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        super.edit(withFrame: adjustedFrameToVerticallyCenterText(frame: rect), in: controlView, editor: textObj, delegate: delegate, event: event)
    }

    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        super.select(withFrame: adjustedFrameToVerticallyCenterText(frame: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: adjustedFrameToVerticallyCenterText(frame: cellFrame), in: controlView)
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.draw(withFrame: cellFrame, in: controlView)
    }
    

}
