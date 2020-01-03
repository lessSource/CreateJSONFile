//
//  HomeData+Extension.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
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
    
    // 用于获取cell的reuse identifire
    public var identifire: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier(String(format: "%@_identifire", self))
    }
    
    // 获取内容
    public func getKeyContent(_ dataType: DataType) -> Data {
        let keyword = APPKeyword()
        return "\(keyword.space4)\(keyword.variable)\(self)\(keyword.colon)\(dataType.valueStr)\(keyword.equal)\(dataType.defaultStr)".wirteData
    }
    

    
}

extension NSObject {
    class var nameOfClass: String {
         return NSStringFromClass(self).components(separatedBy: ".").last! as String
     }
    
    // 用于获取cell的reuse identifire
    class var identifire: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier(String(format: "%@_identifire", self.nameOfClass))
    }
    
}


extension NSColor {
    /** 随机颜色 */
    public class var randomColor: NSColor {
        return NSColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
}


extension Data {
    static func newlineData() -> Data {
        return "\n".data(using: .utf8) ?? Data()
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


extension NSView {
    // 错误提示
    func alertError(_ errorStr: String) {
        let alert = NSAlert()
        alert.messageText = "错误提示"
        alert.informativeText = errorStr
        alert.addButton(withTitle: "确认")
        alert.beginSheetModal(for: self.window ?? NSWindow(), completionHandler: nil)
    }
}
