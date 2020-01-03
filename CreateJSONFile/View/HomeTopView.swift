//
//  HomeTopView.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

enum HomeTopButtomType {
    case generate // 生成
    case validation // 验证
    case check // 切换

}

protocol HomeTopViewDelegate: class {
    func homeTopSelect(_ view: HomeTopView, type: HomeTopButtomType)
}

class HomeTopView: NSView {
    
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
        
        fileNameTextField.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(25)
            $0.width.equalTo(120)
            $0.centerY.equalToSuperview()
        }
        
        checkButton.removeAllItems()
        checkButton.addItems(withTitles: ["HandyJSON","NSObject"])
        checkButton.selectItem(at: 0)
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(110)
            $0.left.equalTo(fileNameTextField.snp.right).offset(10)
        }
        
        generateButton.snp.makeConstraints {
            $0.centerY.right.equalToSuperview()
            $0.width.equalTo(67)
        }
        
        validationButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(67)
            $0.right.equalTo(generateButton.snp.left).offset(-10)
        }

        authorTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(25)
            $0.width.equalTo(80)
            $0.right.equalTo(validationButton.snp.left).offset(-10)
        }
        
        projectNameTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(25)
            $0.width.equalTo(120)
            $0.right.equalTo(authorTextField.snp.left).offset(-10)
        }
        
    }
    
    // MARK:- objc
    @objc fileprivate func generateButtonClick() {
        delegate?.homeTopSelect(self, type: .generate)
    }
    
    @objc fileprivate func validationButtonClick() {
        delegate?.homeTopSelect(self, type: .validation)
    }
    
}
