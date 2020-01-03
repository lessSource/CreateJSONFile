//
//  HomeDataModel.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

struct HomeDataSource {
    /** 头部注释 */
    var fileHeaderArr: Array = [String]()
    /** 继承 */
    var inheritanceStr: String = ""
    /** 内容 */
    var contentArr: Array = [HomeContentModel]()
    
    init() {
        let keyword = APPKeyword()
        fileHeaderArr.removeAll()
        fileHeaderArr.append(keyword.annotationStr)
        fileHeaderArr.append("")
        fileHeaderArr.append("\(keyword.annotationStr)\(App.appName)")
        fileHeaderArr.append(keyword.annotationStr)
        fileHeaderArr.append("")
        fileHeaderArr.append("\(keyword.annotationStr)\(App.copyright)")
        fileHeaderArr.append(keyword.annotationStr)
    }
    
}

struct HomeContentModel {
    /** key */
    var key: String
    /** value */
    var value: String
    /** 是否忽略 */
    var isIgnore: Bool
    /** 输出类型 */
    var outputType: String
    /** 是否有默认值 */
    var isDefault: Bool
    /** 默认值 */
    var defaultStr: String
    /** 注释 */
    var annotation: String
    /** 是否可选 */
    var isOptional: Bool
    
    init(_ key: String, value: String = "", isIgnore: Bool = false, outputType: String = "String", isDefault: Bool = true, defaultStr: String = "", annotation: String = "", isOptional: Bool = false) {
        self.key = key
        self.value = value
        self.isIgnore = isIgnore
        self.outputType = outputType
        self.isDefault = isDefault
        self.defaultStr = defaultStr
        self.annotation = annotation
        self.isOptional = isOptional
    }
}


struct HomeDataModel {
    
    static public func createFileSwift(_ name: String, homeData: HomeDataSource, success: (Bool) ->()) {
        let manager = FileManager.default
        let fileName = "\(name).swift"
        let fileUrl = getFilePath().appendingPathComponent(fileName)
        if manager.fileExists(atPath: fileUrl.path) {
            // 新增数据
            let fileHandle = FileHandle(forUpdatingAtPath: fileUrl.path)
            fileHandle?.seekToEndOfFile()
            
            
            fileHandle?.closeFile()
            return
        }
        if manager.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
            let fileHandle = FileHandle(forUpdatingAtPath: fileUrl.path)
            fileHandle?.seekToEndOfFile()
            // 创建文件头
            homeData.fileHeaderArr.forEach {
                fileHandle?.write($0.wirteData)
                fileHandle?.write(Data.newlineData())
            }
            
            
            
            fileHandle?.closeFile()
        }else {
            success(false)
            print("创建文件失败")
        }
    }
    
    
    // 获取桌面路径 创建时间文件夹
    static fileprivate func getFilePath() -> URL {
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .desktopDirectory, in: .userDomainMask)
        let url = urlForDocument[0]
        let folderUrl = url.appendingPathComponent(Date().formattingDate())
        if !manager.fileExists(atPath: folderUrl.path) {
            do {
                try manager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return url
            }
        }
        return folderUrl
    }
    
}
