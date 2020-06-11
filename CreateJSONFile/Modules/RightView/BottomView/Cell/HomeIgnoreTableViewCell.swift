//
//  HomeIgnoreTableViewCell.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class HomeIgnoreTableViewCell: NSTableCellView {
    
    public lazy var checkButton: NSButton = {
        let button = NSButton(checkboxWithTitle: "", target: self, action: #selector(checkButtonClick))
        button.setButtonType(.switch)
        return button
    }()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    public var model: HomeContentModel? {
        didSet {
            checkButton.state = (model?.isIgnore == true) ? .on : .off
        }
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
        addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK:- objc
    @objc fileprivate func checkButtonClick() {
        model?.isIgnore = !(model?.isIgnore ?? false)
    }
}
