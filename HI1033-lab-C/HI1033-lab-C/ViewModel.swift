//
//  ViewModel.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import SwiftUI
import SQLite3


func saveMood(moodValue: Int) -> String {
    var message: String = "" // Feedback message to the user

    guard let writableDatabasePath = getWritableDatabasePath() else {
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
            message = "Mood saved successfully!"
        } else {
            message = "Failed to save mood."
        }
    } else {
        message = "Failed to prepare statement."
    }

    sqlite3_finalize(stmt)
    
    return message // Return the feedback message
}



