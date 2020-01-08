//
//  HomeTableViewCell.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import SnapKit

class HomeTableViewCell: NSTableCellView {
    
    public var textFieldChangeClosure: ((String) -> ())?
    
    public var didSelectButtonClosure: ((Bool) -> ())?

    
    public var isMouse: Bool = false
    
    public lazy var nameTextField: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.isBordered = false
        textField.font = NSFont.systemFont(ofSize: 16)
        textField.backgroundColor = NSColor.clear
        textField.delegate = self
        textField.cell = BaseTextFieldCell()
        return textField
    }()
    
    fileprivate lazy var addButton: NSButton = {
        let button = NSButton(image: NSImage(named: NSImage.addTemplateName)!, target: self, action: #selector(addButtonClick))
        button.setButtonType(.momentaryPushIn)
        button.isHidden = true
        return button
    }()
    
    fileprivate lazy var reduceButton: NSButton = {
        let button = NSButton(image: NSImage(named: NSImage.removeTemplateName)!, target: self, action: #selector(reduceButtonClick))
        button.setButtonType(.momentaryPushIn)
        button.isHidden = true
        return button
    }()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        if isMouse {
            addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        addButton.isHidden = false
        reduceButton.isHidden = false
    }
    
    override func mouseExited(with event: NSEvent) {
        addButton.isHidden = true
        reduceButton.isHidden = true
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
        addSubview(addButton)
        addSubview(reduceButton)

        nameTextField.snp.makeConstraints({
            $0.height.equalTo(25)
            $0.left.equalTo(5)
            $0.center.equalToSuperview()
        })
        
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
            $0.right.equalToSuperview()
        }
        
        reduceButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
            $0.right.equalTo(addButton.snp.left)
        }
    }
    
    // MARK:- objc
    @objc fileprivate func addButtonClick() {
        didSelectButtonClosure?(true)
    }
    
    @objc fileprivate func reduceButtonClick() {
        didSelectButtonClosure?(false)
    }
}

extension HomeTableViewCell: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        textFieldChangeClosure?(nameTextField.stringValue)
    }
    
}

class BaseTextFieldCell: NSTextFieldCell {
    fileprivate func adjustedFrameToVerticallyCenterText(frame: NSRect) -> NSRect {
        let offset = NSHeight(frame)/2 - ((font?.ascender ?? 0) + (font?.descender ?? 0))
        return NSInsetRect(frame, 0.0, offset)
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
}
