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
    /** json数据 */
    var jsonDic: Dictionary = [String: Any]()
    /** 继承 */
    var inheritanceStr: String = ""
    /** 内容 */
    var contentArr: Array = [HomeContentModel]()
    /** struct名称 */
    var structName: String = ""
    
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
    var value: Any?
    /** 是否忽略 */
    var isIgnore: Bool
    /** 输出类型 */
    var outputType: DataType
    /** 是否有默认值 */
    var isDefault: Bool
    /** 默认值 */
    var defaultStr: String
    /** 注释 */
    var annotation: String
    /** 是否可选 */
    var isOptional: Bool
    /** 子集名称 */
    var childName: String
    /** 子集 */
    var childArr: Array<HomeContentModel>
    
    init(_ key: String, value: Any? = nil, isIgnore: Bool = false, outputType: DataType = .string, isDefault: Bool = true, defaultStr: String = "", annotation: String = "", isOptional: Bool = false,childName: String = "", childArr: Array<HomeContentModel> = [HomeContentModel]()) {
        self.key = key
        self.value = value
        self.isIgnore = isIgnore
        self.outputType = outputType
        self.isDefault = isDefault
        self.defaultStr = defaultStr
        self.annotation = annotation
        self.isOptional = isOptional
        self.childName = childName
        self.childArr = childArr
    }
}


struct HomeDataModel {
    
    // 创建
    static public func createFileSwift(_ name: String, homeData: HomeDataSource, success: (Bool) ->()) {
        let manager = FileManager.default
        let fileName = "\(name).swift"
        let fileUrl = getFilePath().appendingPathComponent(fileName)
        if manager.fileExists(atPath: fileUrl.path) {
            // 新增数据
            let fileHandle = FileHandle(forUpdatingAtPath: fileUrl.path)
            fileHandle?.seekToEndOfFile()
            
            // 添加模型
            wirteStructModel(fileHandle, dataArray: flatStructModel(homeData))

            fileHandle?.closeFile()
            return
        }
        if manager.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
            let fileHandle = FileHandle(forUpdatingAtPath: fileUrl.path)
            let appKeyword = APPKeyword()
            // 将偏移位置设置到文件内容最后
            fileHandle?.seekToEndOfFile()
            // 头部注释
            homeData.fileHeaderArr.forEach {
                fileHandle?.write($0.wirteData)
                fileHandle?.write(Data.newlineData())
            }
            
            // 创建文件头
            fileHandle?.write(Data.newlineData())
            fileHandle?.write("\(appKeyword.imp) \(appKeyword.kit)".wirteData)
            fileHandle?.write(Data.newlineData())
            if homeData.inheritanceStr == appKeyword.handy {
                fileHandle?.write("\(appKeyword.imp) \(appKeyword.handy)".wirteData)
                fileHandle?.write(Data.newlineData())
            }
            
            // 添加模型
            wirteStructModel(fileHandle, dataArray: flatStructModel(homeData))
            
            // 关闭文件
            fileHandle?.closeFile()
        }else {
            success(false)
            print("创建文件失败")
        }
    }
    
    // 格式化数据
    static public func formattingJSON(_ dict: [String: Any]) -> [HomeContentModel] {
        var array = [HomeContentModel]()
        for (key, value) in dict {
            var model = HomeContentModel(key, value: value)
            if let _ = value as? String {
                model.outputType = .string
            }else if let _ = value as? Int {
                model.outputType = .int
            }else if let _ = value as? Bool {
                model.outputType = .bool
            }else if let valueArr = value as? Array<Any> {
                model.outputType = .array("")
                if let dic = valueArr.first as? Dictionary<String, Any> {
                    model.outputType = .array(key)
                    model.childName = "\(key.localizedCapitalized)ArrModel"
                    model.childArr = formattingJSON(dic)
                }
            }else if let valueDic = value as? Dictionary<String, Any> {
                model.outputType = .dictionary(key)
                model.childName = "\(key.localizedCapitalized)DicModel"
                model.childArr = formattingJSON(valueDic)
            }else {
                print(key, value)
            }
            model.defaultStr = model.outputType.defaultStr
            array.append(model)
        }
        return array
    }
    
    // 扁平数据处理
    static fileprivate func flatStructModel(_ homeData: HomeDataSource) -> [HomeDataSource] {
        var array = [HomeDataSource]()
    
        var dataSource = HomeDataSource()
        dataSource.structName = homeData.structName
        dataSource.contentArr = homeData.contentArr
        dataSource.inheritanceStr = homeData.inheritanceStr
        array.append(dataSource)
        
        for item in homeData.contentArr {
            if item.childArr.count > 0 {
                var source = HomeDataSource()
                source.structName = item.defaultStr
                source.contentArr = item.childArr
                source.inheritanceStr = homeData.inheritanceStr
                array += flatStructModel(source)
            }
        }        
        return array
    }
    
    // 添加结构体
    static fileprivate func wirteStructModel(_ fileHandle: FileHandle?, dataArray: [HomeDataSource]) {
        dataArray.forEach {
            addStructModel(fileHandle, homeData: $0)
        }
    }
    
    static fileprivate func addStructModel(_ fileHandle: FileHandle?, homeData: HomeDataSource) {
        let appKeyword = APPKeyword()
        // 机构体开头
        fileHandle?.write(Data.newlineData())
        var structStart: String = ""
        if homeData.inheritanceStr == appKeyword.handy {
            structStart = "\(appKeyword.uct) \(homeData.structName)\(appKeyword.colon) \(appKeyword.handy) \(appKeyword.lPar)"
        }else {
            structStart = "\(appKeyword.uct) \(homeData.structName) \(appKeyword.lPar)"
        }
        fileHandle?.write(structStart.wirteData)
                
        for model in homeData.contentArr {
            if !model.isIgnore {
                if !model.annotation.isEmpty {
                    fileHandle?.write(Data.newlineData())
                    fileHandle?.write(model.key.annotationData)
                }
                fileHandle?.write(Data.newlineData())
                fileHandle?.write(model.key.getKeyContent(model.outputType, defaultStr: model.defaultStr))
            }
        }
        
        // 结构体结束
        fileHandle?.write(Data.newlineData())
        fileHandle?.write("\(appKeyword.rPar)".wirteData)
        fileHandle?.write(Data.newlineData())
        
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
