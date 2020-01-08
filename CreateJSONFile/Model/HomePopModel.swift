//
//  HomePopModel.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/7.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

class HomePopModel {
    /** key */
    var key: String
    /** value */
    var value: String
    /** type */
    var type: DataType
    /** 是否打开 */
    var isOpen: Bool
    /** 禁止编辑 */
    var isEdit: Bool
    /** childContent */
    var childArr: [HomePopModel]
    
    init(key: String = "", value: String = "", type: DataType = .string,isEdit: Bool = true , isOpen: Bool = true , childArr: [HomePopModel] = [HomePopModel]()) {
        self.key = key
        self.value = value
        self.type = type
        self.isEdit = isEdit
        self.isOpen = isOpen
        self.childArr = childArr
    }
}


struct HomePopDataModel {
    
    // 获取header
    static public func getHeaderDictionArray(_ array: [HomePopModel]) -> [String: String] {
        var header = [String: String]()
        for item in array where !item.key.isEmpty {
            header.updateValue(item.value, forKey: item.key)
        }
        return header
    }
    
    // 获取content
    static public func getContentDictionArray(_ popModel: HomePopModel) -> [String: Any] {
        var params = [String: Any]()

        for item in popModel.childArr where !item.key.isEmpty {
            switch item.type {
            case .array(_):
                let param = getContentDictionArray(item)
                var array = [Any]()
                for (_, value) in param {
                    array.append(value)
                }
                params.updateValue(array, forKey: item.key)
            case .dictionary(_):
                params.updateValue(getContentDictionArray(item), forKey: item.key)
            case .bool:
                params.updateValue((item.value as NSString).boolValue, forKey: item.key)
            case .string:
                params.updateValue(item.value, forKey: item.key)
            case .int:
                params.updateValue((item.value as NSString).intValue, forKey: item.key)
            }
        }
        return params
    }
    
}
