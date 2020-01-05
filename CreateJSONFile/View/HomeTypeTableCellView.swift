//
//  HomeTypeTableCellView.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class HomeTypeTableCellView: NSTableCellView {
    
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
        checkButton.removeAllItems()
        checkButton.addItems(withTitles: ["Array","Int","String","Dictionary","Bool"])
        checkButton.selectItem(at: 0)
        
        addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(110)
        }
    }
    
    // MARK:- objc
    @objc fileprivate func checkButtonClick() {
        
    }
    
}
