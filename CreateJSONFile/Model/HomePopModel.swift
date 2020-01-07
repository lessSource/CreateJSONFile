//
//  HomePopModel.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/7.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa

struct HomePopModel {
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
        for item in array {
            header.updateValue(item.value, forKey: item.key)
        }
        return header
    }
    
}
