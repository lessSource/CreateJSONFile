//
//  RequestInputCell.swift
//  CreateJSONFile
//
//  Created by L j on 2020/6/10.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class RequestInputCell: NSTableCellView {
    
    public var textFieldChangeClosure: ((String) -> ())?
    
    public var didSelectButtonClosure = { }
    
    
    public var isMouse: Bool = false {
        didSet {
        }
    }
    
    
    public lazy var nameTextField: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.isBordered = false
        textField.font = NSFont.systemFont(ofSize: 16)
        textField.backgroundColor = NSColor.clear
        textField.delegate = self
        return textField
    }()
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
        if isMouse {
            addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
    }
    
    override func mouseExited(with event: NSEvent) {
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
                
        nameTextField.snp.makeConstraints({
            $0.left.equalTo(5)
            $0.center.equalToSuperview()
        })
        

    }
    
}

extension RequestInputCell: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        textFieldChangeClosure?(nameTextField.stringValue)
    }
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        didSelectButtonClosure()
        return true
    }
    
}


