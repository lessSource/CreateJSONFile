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
    /** required */
    let req = "required"
    /** init */
    let ini = "init"
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
    /** 可选 */
    let optional = "?"
    /** //  */
    let annotationStr = "//  "
    let space4 = "    "
    let space1 = " "
    
}

public enum DataType {
    /** Bool */
    case bool
    /** String */
    case string
    /** Int */
    case int
    /** Array */
    case array(String)
    /** Dictionary */
    case dictionary(String)
    
    var defaultStr: String {
        switch self {
        case .bool:
            return "false"
        case .string:
            return "\"\""
        case .int:
            return "0"
        case .array(let name):
            return name.isEmpty ? "[String]()" : "[\(name.localizedCapitalized)ArrModel]()"
        case .dictionary(let name):
            return "\(name.capitalized)DicModel()"
        }
        
    }
    
    // 写入类型
    var writeStr: String {
        switch self {
        case .bool:
            return "Bool"
        case .int:
            return "Int"
        case .string:
            return "String"
        case .array(_):
            return "Array"
        case .dictionary(let name):
            return name.isEmpty ? "Dictionary" : "\(name.localizedCapitalized)DicModel"

        }
    }
    
    // 输出类型
    var outputStr: String {
        switch self {
        case .bool:
            return "Bool"
        case .array(_):
            return "Array"
        case .string:
            return "String"
        case .dictionary(_):
            return "Dictionary"
        case .int:
            return "Int"
        }
    }
    
}


extension DataType: Equatable {
    static public func ==(lhs: DataType, rhs: DataType) -> Bool {
        switch (lhs, rhs) {
        case (.bool, .bool): return true
        case (.string, .string): return true
        case (.int, .int): return true
        case (.array(let str1), .array(let str2)) where str1 == str2 : return true
        case (.dictionary(let str1), .dictionary(let str2)) where str1 == str2 : return true
        case _: return false
        }
    }

}


