//
//  ActivityViewModel.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import Foundation
import SQLite3

class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var distances: [TotalDistance] = []
    
    let monthOrder: [String: Int] = [
        "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
        "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12
    ]
    
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
    
    func loadActivities() {
        guard let writableDatabasePath = DatabaseManager.shared.getWritableDatabasePath() else {
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

        loadActivityData(db: db)
        loadDistanceData(db: db)
    }
    
    private func loadActivityData(db: OpaquePointer?) {
        let activityQuery = "SELECT Month, ActivityType, Value FROM Activities"
        var activityStmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, activityQuery, -1, &activityStmt, nil) == SQLITE_OK {
            activities.removeAll()
            while sqlite3_step(activityStmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(activityStmt, 0))
                let activityType = String(cString: sqlite3_column_text(activityStmt, 1))
                let value = sqlite3_column_int(activityStmt, 2)

                activities.append(Activity(
                    id: UUID(),
                    month: month,
                    activityType: activityType,
                    value: Int(value)
                ))
            }
        }
        sqlite3_finalize(activityStmt)
    }
    
    private func loadDistanceData(db: OpaquePointer?) {
        let distanceQuery = "SELECT Month, Distance, ActivityType FROM TotalDistance"
        var distanceStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, distanceQuery, -1, &distanceStmt, nil) == SQLITE_OK {
            distances.removeAll()
            while sqlite3_step(distanceStmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(distanceStmt, 0))
                let distance = sqlite3_column_int(distanceStmt, 1)
                let activityType = String(cString: sqlite3_column_text(distanceStmt, 2))
                
                distances.append(TotalDistance(
                    id: UUID(),
                    month: month,
                    distance: Int(distance),
                    activityType: activityType
                ))
            }
        }
        sqlite3_finalize(distanceStmt)
    }
}
