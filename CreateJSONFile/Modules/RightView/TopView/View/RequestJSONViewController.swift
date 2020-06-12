//
//  RequestJSONViewController.swift
//  CreateJSONFile
//
//  Created by Lj on 2020/3/9.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import SwiftyJSON

class RequestJSONViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: - public
    // 返回JSON
    public func setResponseContent(_ json: JSON) {
        print(json.description)
        textView.string = json.description
    }
    
    // 获取json字符串
    public func getResponseContentJson() -> String {
        return textView.string
    }
}
