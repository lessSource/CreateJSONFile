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
    var inheritanceType: InheritanceType
    /* 内容 */
    var contentArr: Array<HomeContentModel>
    /** 文件名称 */
    var fileName: String
    /** 项目名称 */
    var productName: String
    /** 模型类型 */
    var modelType: ModelType
    
    init(inheritanceType: InheritanceType, contentArr: [HomeContentModel], fileName: String, productName: String, modelType: ModelType) {
        self.inheritanceType = inheritanceType
        self.contentArr = contentArr
        self.fileName = fileName
        self.productName = productName
        self.modelType = modelType
        
        let keyword = APPKeyword()
        fileHeaderArr.removeAll()
        fileHeaderArr.append(keyword.annotationStr)
        fileHeaderArr.append("\(keyword.annotationStr)\(fileName).swift")
        let product = productName.isEmpty ? "__projectName__" : productName
        fileHeaderArr.append("\(keyword.annotationStr)\(product)")
        fileHeaderArr.append(keyword.annotationStr)
        fileHeaderArr.append("\(keyword.annotationStr)Created by \(NSUserName()) on \(Date().formattingDate(Date.dateFormatSlashDay))")
        fileHeaderArr.append("\(keyword.annotationStr)Copyright © \(Date().formattingDate(Date.dateForematYear))年 \(NSUserName()). All rights reserved.")
        fileHeaderArr.append(keyword.annotationStr)
    }
}

// struct模型
struct HomeStructModel {
    /** 名称 */
    var structName: String
    /** 继承 */
    var inheritanceType: InheritanceType
    /** 内容 */
    var contentArr: Array<HomeContentModel>
    /** 模型类型 */
    var modelType: ModelType
    
    init(structName: String, contentArr: [HomeContentModel], inheritanceType: InheritanceType = .default, modelType: ModelType) {
        self.structName = structName
        self.contentArr = contentArr
        self.inheritanceType = inheritanceType
        self.modelType = modelType
    }
}


// 内容
class HomeContentModel {
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


struct FileDataModel {
    
    // MARK:- public
    // 创建
    static public func createFileSwift(_ fileUrl: URL, homeData: HomeDataSource, success: (Bool) ->()) {
        let manager = FileManager.default
        if manager.fileExists(atPath: fileUrl.path) {
            // 新增数据
            let fileHandle = FileHandle(forUpdatingAtPath: fileUrl.path)
            fileHandle?.seekToEndOfFile()
            
            // 添加模型
            let structModel = HomeStructModel(structName: homeData.fileName, contentArr: homeData.contentArr, inheritanceType: homeData.inheritanceType, modelType: homeData.modelType)
            wirteStructModel(fileHandle, dataArray: flatStructModel(structModel))
            
            fileHandle?.closeFile()
            return
        }
        
        do {
            var arr = fileUrl.path.components(separatedBy: "/")
            arr.removeLast()
            let path = arr.joined(separator: "/")
            try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
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
            if homeData.inheritanceType != .default {
                fileHandle?.write("\(appKeyword.imp) \(homeData.inheritanceType.inheritStr)".wirteData)
                fileHandle?.write(Data.newlineData())
            }
            
            // 添加模型
            let structModel = HomeStructModel(structName: homeData.fileName, contentArr: homeData.contentArr, inheritanceType: homeData.inheritanceType, modelType: homeData.modelType)
            wirteStructModel(fileHandle, dataArray: flatStructModel(structModel))
            
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
            let model = HomeContentModel(key, value: value)
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
    
    // MARK: - fileprivate
    // 数据处理
    static fileprivate func flatStructModel(_ structData: HomeStructModel) -> [HomeStructModel] {
        var array = [HomeStructModel]()
        array.append(structData)
        
        for item in structData.contentArr {
            if item.childArr.count > 0 && !item.isIgnore {
                let model = HomeStructModel(structName: item.childName, contentArr: item.childArr, inheritanceType: structData.inheritanceType, modelType: structData.modelType)
                array += flatStructModel(model)
            }
        }
        
        return array
    }
    
    // 添加结构体
    static fileprivate func wirteStructModel(_ fileHandle: FileHandle?, dataArray: [HomeStructModel]) {
        dataArray.forEach {
            addStructModel(fileHandle, structModel: $0)
        }
    }
    
    // 写文件
    static fileprivate func addStructModel(_ fileHandle: FileHandle?, structModel: HomeStructModel) {
        let appKeyword = APPKeyword()
        // 机构体开头
        fileHandle?.write(Data.newlineData())
        var structStart: String = ""
        if structModel.inheritanceType != .default {
            structStart = "\(structModel.modelType.rawValue) \(structModel.structName)\(appKeyword.colon) \(structModel.inheritanceType.inheritStr) \(appKeyword.lPar)"
        }else {
            structStart = "\(structModel.modelType.rawValue) \(structModel.structName) \(appKeyword.lPar)"
        }
        fileHandle?.write(structStart.wirteData)
        
        for model in structModel.contentArr {
            if !model.isIgnore {
                if !model.annotation.isEmpty {
                    fileHandle?.write(Data.newlineData())
                    fileHandle?.write(model.annotation.annotationData)
                }
                fileHandle?.write(Data.newlineData())
                fileHandle?.write(model.key.getKeyContent(model.outputType, defaultStr: model.defaultStr))
            }
        }
        
        if structModel.modelType == .classType {
            fileHandle?.write(Data.newlineData())
            fileHandle?.write(Data.newlineData())
            if structModel.inheritanceType == .mapper {
                if structModel.modelType == .classType {
                    fileHandle?.write("\(appKeyword.space4)required init?(map: Map) {  }".wirteData)
                }else {
                    fileHandle?.write("\(appKeyword.space4)init?(map: Map) { }".wirteData)
                }
                
            }else {
                fileHandle?.write("\(appKeyword.space4)required init() { }".wirteData)
            }
        }
        
        if structModel.inheritanceType == .mapper {
            fileHandle?.write(Data.newlineData())
            fileHandle?.write(Data.newlineData())
            fileHandle?.write("\(appKeyword.space4)mutating func mapping(map: Map) {".wirteData)
            
            for model in structModel.contentArr {
                if !model.isIgnore {
                    fileHandle?.write(Data.newlineData())
                    fileHandle?.write(model.key.getKeyMapping())
                }
            }
            fileHandle?.write(Data.newlineData())
            fileHandle?.write("\(appKeyword.space4)\(appKeyword.rPar)".wirteData)
        }
        
        
        // 结构体结束
        fileHandle?.write(Data.newlineData())
        fileHandle?.write("\(appKeyword.rPar)".wirteData)
        fileHandle?.write(Data.newlineData())
        
    }
    
}
