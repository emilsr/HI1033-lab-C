//
//  DatabaseManager..swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import SQLite3
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()

    private init() {}

    func fetchActivities() -> [Activity] {
        var activities: [Activity] = []
        guard let db = openDatabase() else { return activities }
        defer { sqlite3_close(db) }

        let query = "SELECT Month, ActivityType, Value FROM Activities"
        var stmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(stmt, 0))
                let activityType = String(cString: sqlite3_column_text(stmt, 1))
                let value = sqlite3_column_int(stmt, 2)

                activities.append(Activity(
                    id: UUID(),
                    month: month,
                    activityType: activityType,
                    value: Int(value)
                ))
            }
        }
        sqlite3_finalize(stmt)
        return activities
    }

    func fetchDistances() -> [TotalDistance] {
        var distances: [TotalDistance] = []
        guard let db = openDatabase() else { return distances }
        defer { sqlite3_close(db) }

        let query = "SELECT Month, Distance, ActivityType FROM TotalDistance"
        var stmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(stmt, 0))
                let distance = sqlite3_column_int(stmt, 1)
                let activityType = String(cString: sqlite3_column_text(stmt, 2))

                distances.append(TotalDistance(
                    id: UUID(),
                    month: month,
                    distance: Int(distance),
                    activityType: activityType
                ))
            }
        }
        sqlite3_finalize(stmt)
        return distances
    }

    func fetchMoods() -> [MonthlyMood] {
        var moods: [MonthlyMood] = []
        guard let db = openDatabase() else { return moods }
        defer { sqlite3_close(db) }

        let query = "YOUR RECURSIVE SQL QUERY"
        var stmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(stmt, 0))
                let averageMood = sqlite3_column_double(stmt, 1)

                moods.append(MonthlyMood(
                    id: UUID(),
                    month: month,
                    averageMood: averageMood
                ))
            }
        }
        sqlite3_finalize(stmt)
        return moods
    }

    private func openDatabase() -> OpaquePointer? {
        guard let path = getWritableDatabasePath() else { return nil }
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) != SQLITE_OK {
            return nil
        }
        return db
    }

    private func getWritableDatabasePath() -> String? {
        let fileManager = FileManager.default

        // Get the Documents directory path
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let writableDatabasePath = documentsDirectory.appendingPathComponent("activities-3.db").path

        // Check if the database file already exists in the Documents directory
        if !fileManager.fileExists(atPath: writableDatabasePath) {
            // Get the database path in the app bundle
            guard let bundledDatabasePath = Bundle.main.path(forResource: "activities-3", ofType: "db") else {
                print("Database not found in the bundle.")
                return nil
            }

            do {
                // Copy the database to the writable directory
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
