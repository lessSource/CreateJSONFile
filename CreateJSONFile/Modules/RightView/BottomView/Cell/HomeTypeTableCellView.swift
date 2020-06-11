//
//  HomeTypeTableCellView.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class HomeTypeTableCellView: NSTableCellView {
    
    public var didSelectCheck = { }
    
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
    
    public var model: HomeContentModel? {
        didSet {
            checkButton.selectItem(withTitle: model?.outputType.outputStr ?? "")
            switch model?.outputType {
            case .array(_), .dictionary(_):
                checkButton.isEnabled = model?.childArr.count == 0
            default:
                checkButton.isEnabled = true
            }
        }
    }
    
    // MARK:- initView
    fileprivate func initView() {
        checkButton.removeAllItems()
        checkButton.addItems(withTitles: ["Array","Int","String","Dictionary","Bool"])
        checkButton.selectItem(at: 0)
        checkButton.target = self
        checkButton.action = #selector(checkButtonClick)
        
        addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(110)
        }
        
    }
    
    // MARK:- objc
    @objc fileprivate func checkButtonClick() {
        switch checkButton.title {
        case "Array":
            model?.outputType = .array("")
        case "Int":
            model?.outputType = .int
        case "Dictionary":
            model?.outputType = .dictionary("")
        case "Bool":
            model?.outputType = .bool
        default:
            model?.outputType = .string
        }
        didSelectCheck()
    }
    
 
    
}
