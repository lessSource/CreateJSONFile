//
//  ViewController.swift
//  CreateJSONFile
//
//  Created by less on 2019/12/31.
//  Copyright © 2019 Less. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftyJSON


class ViewController: NSViewController {
    // 关键字
    fileprivate let appKeyword = APPKeyword()
            
    fileprivate var annotationArr = [String]()
    
    fileprivate var contentArray = [[String: Any]()]
        
    @IBOutlet weak var fileNameTextField: NSTextField!
    
    @IBOutlet weak var authorTextField: NSTextField!
    
    @IBOutlet weak var projectNameTextField: NSTextField!
        
    @IBOutlet var jsonContentTextView: NSTextView!
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    @IBOutlet weak var generateButton: NSButton!
        
    @IBOutlet weak var selectButton: NSPopUpButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.window?.title = App.appName
        
        annotationArr = [appKeyword.annotationStr, "","\(appKeyword.annotationStr)\(App.appName)", appKeyword.annotationStr, "", "\(appKeyword.annotationStr)\(App.copyright)", appKeyword.annotationStr]
        initView()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    fileprivate func initView() {
        selectButton.removeAllItems()
        selectButton.addItems(withTitles: ["HandyJSON","NSObject"])
        selectButton.selectItem(at: 0)
        
    }
    
    @IBAction func generateButtonClick(_ sender: NSButton) {
        contentArray.removeAll()
        let fileName = fileNameTextField.stringValue.pregReplace(pattern: "[. ]", with: "")
        let authorName = authorTextField.stringValue.pregReplace(pattern: "[. ]", with: "")
        let projectName = projectNameTextField.stringValue.pregReplace(pattern: "[. ]", with: "")

        
        if !projectName.isEmpty {
            annotationArr[2] = "\(appKeyword.annotationStr)\(projectName)"
        }
        if !fileName.isEmpty && !authorName.isEmpty && !jsonContentTextView.string.isEmpty {
            annotationArr[1] = "\(appKeyword.annotationStr)\(fileName).swift"
            annotationArr[4] = "\(appKeyword.annotationStr)Created by \(authorName) on \(Date().formattingDate(Date.dateFormatSlashDay))."
            guard let dict = JSON(parseJSON: jsonContentTextView.string).dictionaryObject else {
                view.alertError("请输入正确的JSON数据")
                return
            }
            jsonContentTextView.string = JSON(parseJSON: jsonContentTextView.string).description
            contentArray.append(dict)
            createFileSiwft(fileName)
        }else {
            if fileName.isEmpty {
               view.alertError("请输入文件名称")
            }else if authorName.isEmpty {
                view.alertError("请输入作者名称")
            }else if jsonContentTextView.string.isEmpty {
                view.alertError("请输入JSON数据")
            }
        }
    }
    
    @IBAction func selectButtonClick(_ sender: NSPopUpButton) {
        
    }
    
    
    // 获取文件路径
    fileprivate func createFileSiwft(_ name: String) {
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .desktopDirectory, in: .userDomainMask)
        let url = urlForDocument[0]
        createFile(name: "\(name).swift", fileBaseUrl: url)
    }
    
    // 创建文件、写入数据
    fileprivate func createFile(name: String, fileBaseUrl: URL) {
        let manager = FileManager.default
        let folderNameUrl = fileBaseUrl.appendingPathComponent(Date().formattingDate())
        if !manager.fileExists(atPath: folderNameUrl.path) {
            do {
                try manager.createDirectory(at: folderNameUrl, withIntermediateDirectories: true, attributes: nil)
                print("Succes to create folder")
            } catch {
                print("Error to create folder")
                return
            }
        }
        let fileUrl = folderNameUrl.appendingPathComponent(name)
        if manager.fileExists(atPath: fileUrl.path) {
            // 添加数据
            print("新增数据")
            let fileHandle = FileHandle(forUpdatingAtPath: fileUrl.path)
            fileHandle?.seekToEndOfFile()
            
            // 新增结构体
            addStructModel(fileHandle, name: name)
            
            fileHandle?.closeFile()
            return
        }
        if manager.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
            let fileHandle = FileHandle(forUpdatingAtPath: fileUrl.path)
            fileHandle?.seekToEndOfFile()
            
            // 头部
            annotationArr.forEach {
                fileHandle?.write($0.wirteData)
                fileHandle?.write(Data.newlineData())
            }
            // 头文件
            fileHandle?.write(Data.newlineData())
            fileHandle?.write("\(appKeyword.imp) \(appKeyword.kit)".wirteData)
            fileHandle?.write(Data.newlineData())
            if selectButton.title == appKeyword.handy {
                fileHandle?.write("\(appKeyword.imp) \(appKeyword.handy)".wirteData)
                fileHandle?.write(Data.newlineData())
            }
            
            // 添加结构体
            addStructModel(fileHandle, name: name)
            
            // 关闭文件
            fileHandle?.closeFile()
            print("Succes to create file")
        }else {
            print("Error to create file")
        }
    }
    
    // 添加结构体
    fileprivate func addStructModel(_ fileHandle :FileHandle?, name: String) {
        // 结构体开头
        fileHandle?.write(Data.newlineData())
        var structStart: String = ""
        if selectButton.title == appKeyword.handy {
            structStart = "\(appKeyword.uct) \(name.components(separatedBy: ".").first.noneNull)\(appKeyword.colon) \(appKeyword.handy) \(appKeyword.lPar)"
        }else {
            structStart = "\(appKeyword.uct) \(name.components(separatedBy: ".").first.noneNull) \(appKeyword.lPar)"
        }
        fileHandle?.write(structStart.wirteData)
        // 结构体内容
        if contentArray.count > 0 {
            traverseContent(fileHandle, dict: contentArray[0])
        }
        
        // 结构体结束
        fileHandle?.write(Data.newlineData())
        fileHandle?.write("\(appKeyword.rPar)".wirteData)
        fileHandle?.write(Data.newlineData())
        
        contentArray.removeFirst()
        if contentArray.count != 0 {
            addStructModel(fileHandle, name: "APPNameModel")
        }
        
    }
    
    // 添加属性
    fileprivate func addStructConent(_ fileHandle :FileHandle?, key: String, annotationStr: String = "", dataType: DataType = .str) {
        if !annotationStr.isEmpty {
            fileHandle?.write(Data.newlineData())
            fileHandle?.write(annotationStr.annotationData)
        }
        fileHandle?.write(Data.newlineData())
        fileHandle?.write(key.getKeyContent(dataType))
    }
    
    // 遍历content
    fileprivate func traverseContent(_ fileHandle :FileHandle?, dict: [String: Any]?) {
        for (key, value) in dict ?? [String: Any]() {
            if let valueStr = value as? String {
                print(valueStr)
                addStructConent(fileHandle, key: key)
            }else if let valueArr = value as? Array<Any> {
                print(valueArr)
            }else if let valueDic = value as? Dictionary<String, Any> {
//                addStructConent(fileHandle, key: key, annotationStr: key, dataType: .model(key))
                contentArray.append(valueDic)
                print(valueDic)
            }else {
                addStructConent(fileHandle, key: key)
            }
        }
    }
    

}


