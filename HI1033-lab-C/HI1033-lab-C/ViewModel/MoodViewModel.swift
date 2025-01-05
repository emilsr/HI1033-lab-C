//
//  MoodViewModel.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import Foundation
import SQLite3

class MoodViewModel: ObservableObject {
    @Published var moodValue: Int = 3
    @Published var moods: [MonthlyMood] = []
    
    func saveMood() -> String {
        guard let writableDatabasePath = DatabaseManager.shared.getWritableDatabasePath() else {
            return "Database path not found."
        }

        var db: OpaquePointer? = nil
        if sqlite3_open(writableDatabasePath, &db) != SQLITE_OK {
            return "Unable to open database."
        }

        defer {
            sqlite3_close(db)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())

        let insertQuery = """
        INSERT INTO MoodEvaluation (Date, Mood)
        VALUES (?, ?)
        ON CONFLICT(Date)
        DO UPDATE SET Mood = excluded.Mood;
        """

        var stmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, todayDate, -1, nil)
            sqlite3_bind_int(stmt, 2, Int32(moodValue))

            if sqlite3_step(stmt) == SQLITE_DONE {
                sqlite3_finalize(stmt)
                return "Mood saved successfully!"
            } else {
                sqlite3_finalize(stmt)
                return "Failed to save mood."
            }
        } else {
            sqlite3_finalize(stmt)
            return "Failed to prepare statement."
        }
    }
    
    func loadMoods() {
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

        let moodQuery = """
        WITH RECURSIVE Months(Month) AS (
          SELECT 'Jan'
          UNION ALL
          SELECT CASE Month 
            WHEN 'Jan' THEN 'Feb'
            WHEN 'Feb' THEN 'Mar'
            WHEN 'Mar' THEN 'Apr'
            WHEN 'Apr' THEN 'May'
            WHEN 'May' THEN 'Jun'
            WHEN 'Jun' THEN 'Jul'
            WHEN 'Jul' THEN 'Aug'
            WHEN 'Aug' THEN 'Sep'
            WHEN 'Sep' THEN 'Oct'
            WHEN 'Oct' THEN 'Nov'
            WHEN 'Nov' THEN 'Dec'
          END
          FROM Months
          WHERE Month != 'Dec'
        )
        SELECT 
            m.Month,
            COALESCE(ROUND(AVG(CAST(me.Mood AS FLOAT)), 2), 0) as AverageMood
        FROM Months m
        LEFT JOIN (
            SELECT 
                CASE 
                    WHEN substr(Date, 6, 2) = '01' THEN 'Jan'
                    WHEN substr(Date, 6, 2) = '02' THEN 'Feb'
                    WHEN substr(Date, 6, 2) = '03' THEN 'Mar'
                    WHEN substr(Date, 6, 2) = '04' THEN 'Apr'
                    WHEN substr(Date, 6, 2) = '05' THEN 'May'
                    WHEN substr(Date, 6, 2) = '06' THEN 'Jun'
                    WHEN substr(Date, 6, 2) = '07' THEN 'Jul'
                    WHEN substr(Date, 6, 2) = '08' THEN 'Aug'
                    WHEN substr(Date, 6, 2) = '09' THEN 'Sep'
                    WHEN substr(Date, 6, 2) = '10' THEN 'Oct'
                    WHEN substr(Date, 6, 2) = '11' THEN 'Nov'
                    WHEN substr(Date, 6, 2) = '12' THEN 'Dec'
                END as Month,
                Mood
            FROM MoodEvaluation
        ) me ON m.Month = me.Month
        GROUP BY m.Month
        ORDER BY (
            CASE m.Month
                WHEN 'Jan' THEN 1
                WHEN 'Feb' THEN 2
                WHEN 'Mar' THEN 3
                WHEN 'Apr' THEN 4
                WHEN 'May' THEN 5
                WHEN 'Jun' THEN 6
                WHEN 'Jul' THEN 7
                WHEN 'Aug' THEN 8
                WHEN 'Sep' THEN 9
                WHEN 'Oct' THEN 10
                WHEN 'Nov' THEN 11
                WHEN 'Dec' THEN 12
            END)
        """
        
        var moodStmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, moodQuery, -1, &moodStmt, nil) == SQLITE_OK {
            moods.removeAll()
            
            while sqlite3_step(moodStmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(moodStmt, 0))
                let averageMood = sqlite3_column_double(moodStmt, 1)

                moods.append(MonthlyMood(
                    id: UUID(),
                    month: month,
                    averageMood: averageMood
                ))
            }
        }
        sqlite3_finalize(moodStmt)
    }
}
