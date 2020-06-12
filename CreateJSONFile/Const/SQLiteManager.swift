//
//  SQLiteManager.swift
//  CreateJSONFile
//
//  Created by L j on 2020/6/12.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import SQLite

enum DataAccessError: Swift.Error {
    case datastorConnectionError
    case inserError
    case deleteError
    case scearchError
    case nilInData
    case nomoreData
}

class SQLiteManager {
    
    static let sharedInstance = SQLiteManager()
    
    var db: Connection?
    
    private init() {
        var path =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first!
        path.append("/\(App.appName)db.sqlite")
        print(path)
        do {
            db = try Connection(path)
            db?.busyTimeout = 5
            db?.busyHandler({ (tries) -> Bool in
                if tries >= 3 {
                    return false
                }
                return true
            })
            
        } catch _ {
            db = nil
        }
    }
    
    func createTables() throws {
        do {
            try LDataHelper.createTable()
        } catch {
            throw DataAccessError.datastorConnectionError
        }
    }
}

protocol LDataHalperProtocol {
    associatedtype T
    
    static func createTable() throws -> Void
    
    static func insert(item: T) throws -> Int
    
    static func check(queryId: String) throws -> [T]
}

extension LDataHalperProtocol {
    
    static func update(id: Int, value: T) throws -> T? { return nil }
    
    static func update(item: T) throws -> Bool { return false }
    
    static func delete(item: T) throws -> Bool { return false }
    
    static func findAll() throws -> [T]? { return nil }
    
    static func checkColimnExists(queryId: String) throws -> Bool { return false }
}


class LDataHelper: LDataHalperProtocol {
    
    static let TABLE_NAME = "historyTabel"
    
    static let PRIMARY_KEY = Expression<Int64>("primary_key")
    
    static let REQUEST_ID = Expression<String>("request_id")
    static let REQUEST_TYPE = Expression<String>("request_type")
    static let REQUEST_URL = Expression<String>("request_url")
    static let REQUEST_HEADER = Expression<String>("request_header")
    
    static let table = Table(TABLE_NAME)
    
    typealias T = LHistoryModel
    
    static func createTable() throws {
        guard let db = SQLiteManager.sharedInstance.db else {
            throw DataAccessError.datastorConnectionError
        }
        do {
            _ = try db.run(table.create(ifNotExists: true, block: { t in
                // 主键
                t.column(PRIMARY_KEY, primaryKey: .autoincrement)
                t.column(REQUEST_ID)
                t.column(REQUEST_TYPE)
                t.column(REQUEST_URL)
                t.column(REQUEST_HEADER)
                
            }))
        } catch _ {
            throw DataAccessError.datastorConnectionError
        }
        
    }
    
    static func insert(item: LHistoryModel) throws -> Int {
        guard let db = SQLiteManager.sharedInstance.db else {
            throw DataAccessError.datastorConnectionError
        }
        let insert = table.insert(REQUEST_ID <- item.requestId)
        
        do {
            let rowId = try db.run(insert)
            guard rowId >= 0 else {
                throw DataAccessError.inserError
            }
            return Int(rowId)
        } catch _ {
            throw DataAccessError.inserError
        }
    }
    
    static func update(item: LHistoryModel) throws -> Bool {
        guard let db = SQLiteManager.sharedInstance.db else {
            throw DataAccessError.datastorConnectionError
        }
        let query = table.filter(item.requestId == REQUEST_ID)
        
        if try db.run(query.update(REQUEST_ID <- item.requestId)) > 0 {
            return true
        }else {
            return false
        }
    }
    
    
    
    static func checkColimnExists(queryId: String) throws -> Bool {
        guard let db = SQLiteManager.sharedInstance.db else {
            throw DataAccessError.datastorConnectionError
        }
        let query = table.filter(queryId == REQUEST_ID).exists
        
        let isExists = try db.scalar(query)
        return isExists
    }
    
    static func delete(item: LHistoryModel) throws -> Bool {
        guard let db = SQLiteManager.sharedInstance.db else {
            throw DataAccessError.datastorConnectionError
        }
        
        let query = table.filter(REQUEST_ID == item.requestId)
        do {
            let tmp = try db.run(query.delete())
            
            guard tmp == 1 else {
                throw DataAccessError.deleteError
            }
        } catch _ {
            throw DataAccessError.deleteError
        }
        return true
    }
    
    static func check(queryId: String) throws -> [LHistoryModel] {
        guard let db = SQLiteManager.sharedInstance.db else {
            throw DataAccessError.datastorConnectionError
        }
        let query = table.filter(queryId == REQUEST_ID)
        let items = try db.prepare(query)
        var retArray = [LHistoryModel]()
        for item in items {
            
            retArray.append(LHistoryModel(requestId: item[REQUEST_ID], requestType: item[REQUEST_TYPE], requestUrl: item[REQUEST_URL], requestHeader: item[REQUEST_HEADER]))
        }
        return retArray
    }
    
    static func findAll() throws -> [LHistoryModel] {
        guard let db = SQLiteManager.sharedInstance.db else {
            throw DataAccessError.datastorConnectionError
        }
        var retArray = [LHistoryModel]()
        let items = try db.prepare(table)
        for item in items {
            retArray.append(LHistoryModel(requestId: item[REQUEST_ID], requestType: item[REQUEST_TYPE], requestUrl: item[REQUEST_URL], requestHeader: item[REQUEST_HEADER]))
        }
        return retArray
    }
    
    
    
}


struct LHistoryModel {
    /** 唯一标识 */
    var requestId: String = ""
    /** 请求类型 */
    var requestType: String = ""
    /** 请求地址 */
    var requestUrl: String = ""
    /** 请求header */
    var requestHeader: String = ""
    
}

//extension UIImage: Value {
//
//    // SQL Type
//    public static var declaredDatatype: String {
//        return Blob.declaredDatatype
//    }
//
//    public static func fromDatatypeValue(_ blobValue: Blob) -> UIImage {
//        return UIImage(data: Data.fromDatatypeValue(blobValue))!
//    }
//
//    public var datatypeValue: Blob {
//        return self.pngData()!.datatypeValue
//    }
//
//}

