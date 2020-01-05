//
//  AboutApp.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/2.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa


public struct App {
    private static var info: Dictionary<String, Any> {
        return Bundle.main.infoDictionary ?? [String: Any]()
    }
    
    /** 名称 */
    public static var appName: String {
        return info["CFBundleName"] as? String ?? ""
    }
    
    /** 版权信息 */
    public static var copyright: String {
        return info["NSHumanReadableCopyright"] as? String ?? ""
    }
    
}

struct APPKeyword {
    /** 导入 */
    let imp = "import"
    /** UIKit */
    let kit = "UIKit"
    /** struct */
    let uct = "struct"
    /** HandyJSON */
    let handy = "HandyJSON"
    /** { */
    let lPar = "{"
    /** } */
    let rPar = "}"
    /** {} */
    let par = "{}"
    /** ( */
    let sLPar = "("
    /** ) */
    let sRPar = ")"
    /** () */
    let sPar = "()"
    /** [ */
    let mLPar = "["
    /** ] */
    let mRPar = "]"
    /** [] */
    let mPar = "[]"
    /** = */
    let equal = " = "
    /** 0 */
    let zero = "0"
    /** var */
    let variable = "var "
    /** let */
    let constant = "let "
    /** "" */
    let quotes = "\"\""
    /** false */
    let fal = "false"
    /** true */
    let tru = "true"
    /** 注释开头 */
    let sAnnotation = "/** "
    /** 注释结尾 */
    let eAnnotation = " */"
    /** : */
    let colon = ":"
    /** //  */
    let annotationStr = "//  "
    let space4 = "    "
    let space1 = " "
}

public enum DataType {
    /** Bool */
    case bool
    /** Array */
    case array
    /** String */
    case string
    /** Int */
    case int
    /** Dictionary */
    case dictionary
    /** model */
    case model(String)
    
    var defaultStr: String {
        switch self {
        case .bool:
            return "false"
        case .array:
            return "[]"
        case .dictionary:
            return "[]"
        case .string:
            return "\"\""
        case .int:
            return "0"
        case .model(let name):
            return "\(name)Model()"
        }
    }
    
    var valueStr: String {
        switch self {
        case .bool:
            return "Bool"
        case .array:
            return "Array"
        case .string:
            return "String"
        case .dictionary:
            return "Dictionary"
        case .int:
            return "Int"
        case .model(let name):
            return "\(name)Model"
        }
    }
    
}


extension DataType: Equatable {
    static public func ==(lhs: DataType, rhs: DataType) -> Bool {
        switch (lhs, rhs) {
        case (.bool, .bool): return true
        case (.array, .array): return true
        case (.string, .string): return true
        case (.dictionary, .dictionary): return true
        case (.int, .int): return true
        case (.model(let str1), .model(let str2)) where str1 == str2 : return true
        case _: return false
        }
    }

}


