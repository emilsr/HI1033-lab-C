//
//  ActivityMoodLogicActivityMoodLogic.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

/*

import Foundation
import SQLite3

struct Activity: Identifiable {
    let id: UUID
    let month: String
    let activityType: String
    let value: Int
}

struct TotalDistance: Identifiable {
    let id: UUID
    let month: String
    let distance: Int
    let activityType: String
}

struct MonthlyMood: Identifiable {
    let id: UUID
    let month: String
    let averageMood: Double
}

extension ActivityMoodScreen {
    // Constants
    private var monthOrder: [String: Int] {
        [
            "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
            "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12
        ]
    }

    private var months: [String] {
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    }

    // Helper Methods
    func groupedActivities() -> [(key: String, value: [Activity])] {
        let grouped = Dictionary(grouping: activities) { $0.activityType }
        return grouped.map { activityType, activities in
            let sortedActivities = activities.sorted { a, b in
                (monthOrder[a.month] ?? 0) < (monthOrder[b.month] ?? 0)
            }
            return (key: activityType, value: sortedActivities)
        }
        .sorted { $0.key < $1.key }
    }
    
    func groupedDistances() -> [(key: String, value: [TotalDistance])] {
        let grouped = Dictionary(grouping: distances) { $0.month }
        return grouped.map { month, distances in
            let sortedDistances = distances.sorted { a, b in
                a.activityType < b.activityType
            }
            return (key: month, value: sortedDistances)
        }
        .sorted { (monthOrder[$0.key] ?? 0) < (monthOrder[$1.key] ?? 0) }
    }

    func loadData() {
        guard let writableDatabasePath = getWritableDatabasePath() else {
            print("Database path not found.")
            return
        }

        var db: OpaquePointer? = nil
        if sqlite3_open(writableDatabasePath, &db) != SQLITE_OK {
            print("Unable to open database.")
            return
        }

        defer {
            sqlite3_close(db)
        }

        // Load activities
        activities = fetchActivities(from: db)
        distances = fetchDistances(from: db)
        moods = fetchMoods(from: db)
    }

    private func fetchActivities(from db: OpaquePointer?) -> [Activity] {
        var results: [Activity] = []
        let query = "SELECT Month, ActivityType, Value FROM Activities"
        var stmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(stmt, 0))
                let activityType = String(cString: sqlite3_column_text(stmt, 1))
                let value = sqlite3_column_int(stmt, 2)

                results.append(Activity(
                    id: UUID(),
                    month: month,
                    activityType: activityType,
                    value: Int(value)
                ))
            }
        }

        sqlite3_finalize(stmt)
        return results
    }

    private func fetchDistances(from db: OpaquePointer?) -> [TotalDistance] {
        var results: [TotalDistance] = []
        let query = "SELECT Month, Distance, ActivityType FROM TotalDistance"
        var stmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(stmt, 0))
                let distance = sqlite3_column_int(stmt, 1)
                let activityType = String(cString: sqlite3_column_text(stmt, 2))

                results.append(TotalDistance(
                    id: UUID(),
                    month: month,
                    distance: Int(distance),
                    activityType: activityType
                ))
            }
        }

        sqlite3_finalize(stmt)
        return results
    }

    private func fetchMoods(from db: OpaquePointer?) -> [MonthlyMood] {
        var results: [MonthlyMood] = []
        let query = """
            -- Query for fetching moods
        """
        var stmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(stmt, 0))
                let averageMood = sqlite3_column_double(stmt, 1)

                results.append(MonthlyMood(
                    id: UUID(),
                    month: month,
                    averageMood: averageMood
                ))
            }
        }

        sqlite3_finalize(stmt)
        return results
    }
}
*/
