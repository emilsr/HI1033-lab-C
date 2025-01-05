//
//  DatabaseManager.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    func getWritableDatabasePath() -> String? {
        let fileManager = FileManager.default

        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let writableDatabasePath = documentsDirectory.appendingPathComponent("activities-3.db").path

        if !fileManager.fileExists(atPath: writableDatabasePath) {
            guard let bundledDatabasePath = Bundle.main.path(forResource: "activities-3", ofType: "db") else {
                print("Database not found in the bundle.")
                return nil
            }

            do {
                try fileManager.copyItem(atPath: bundledDatabasePath, toPath: writableDatabasePath)
                print("Database copied to writable directory.")
            } catch {
                print("Failed to copy database: \(error.localizedDescription)")
                return nil
            }
        }
        print("File path:" + writableDatabasePath)
        return writableDatabasePath
    }
}
