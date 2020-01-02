//
//  AboutApp.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/2.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

public protocol OptionalString { }
extension String: OptionalString { }

public extension Optional where Wrapped: OptionalString {
    // 对可选类型的String(String?)安全解包
    var noneNull: String {
        if let value = self as? String {
            return value
        }else {
            return ""
        }
    }
    
    // 解包可选字符串，并对空字符串设置默认值
    // - defaultStr: 默认值
    func noneNull(defaultStr: String) -> String {
        if self.noneNull.isEmpty {
            return defaultStr
        }else {
            return self.noneNull
        }
    }
    
    
}

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

extension Date {
    // dateFormat
    static var dateFormatDay: String {
        return "yyyy-MM-dd"
    }
    
    static var dateFormatSlashDay: String {
        return "yyyy/MM/dd"
    }
    
    static var dateFormatMonth: String {
        return "MM-dd HH:mm"
    }
    
    static var dateFormatSeconds: String {
        return "yyyy-MM-dd HH:mm:ss"
    }
    
    static var dateFormatZone: String {
        return "yyyy-MM-dd 'T'HH:mm:ss.SSS+SSSS'Z'"
    }
    
    // 格式化时间
    func formattingDate(_ dateFormat: String = dateFormatDay) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: self)
    }
}

extension String {
    func pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: with)
    }
    
    public var wirteData: Data {
        return self.data(using: .utf8) ?? Data()
    }
    
    // 获取注释
    public var annotationData: Data {
        let keyword = APPKeyword()
        return "\(keyword.space4)\(keyword.sAnnotation)\(self)\(keyword.eAnnotation)".wirteData
    }
    
    // 获取内容
    public func getKeyContent(_ dataType: DataType) -> Data {
        let keyword = APPKeyword()
        return "\(keyword.space4)\(keyword.variable)\(self)\(keyword.colon)\(dataType.rawValue)\(keyword.equal)\(dataType.defaultStr)".wirteData
    }
}


extension Data {
    static func newlineData() -> Data {
        return "\n".data(using: .utf8) ?? Data()
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
    let space4 = "    "
    let space1 = " "
}

public enum DataType: String {
    /** Bool */
    case bool = " Bool"
    /** Array */
    case arr = " Array"
    /** String */
    case str = " String"
    /** Int */
    case int = " Int"
    
    var defaultStr: String {
        switch self {
        case .bool:
            return "false"
        case .arr:
            return "[]"
        case .str:
            return "\"\""
        case .int:
            return "0"
        }
    }
    
}
