//
//  DataBaseHelper.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-04.
//

import SQLite3
import Foundation

class DatabaseHelper {
    static func openDatabase() -> OpaquePointer? {
        let databasePath = Bundle.main.path(forResource: "activities-3", ofType: "db")
        guard let path = databasePath else {
            print("Database not found.")
            return nil
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("Unable to open database.")
            return nil
        }
        
        return db
    }
    
    static func closeDatabase(_ db: OpaquePointer?) {
        if let db = db {
            sqlite3_close(db)
        }
    }
}
