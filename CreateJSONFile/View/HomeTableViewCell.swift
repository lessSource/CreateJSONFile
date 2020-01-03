//
//  HomeTableViewCell.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class HomeTableViewCell: NSTableCellView {
    
    fileprivate lazy var nameTextField: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.isEditable = false
        textField.isBordered = false
        textField.font = NSFont.systemFont(ofSize: 16)
        textField.backgroundColor = NSColor.clear
        return textField
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
        addSubview(nameTextField)
        nameTextField.stringValue = "1231792"
        nameTextField.snp.makeConstraints({
            $0.edges.equalTo(NSEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        })
    }
    

    
}
