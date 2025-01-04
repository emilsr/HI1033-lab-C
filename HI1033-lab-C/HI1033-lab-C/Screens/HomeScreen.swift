//
//  HomeScreen.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-04.
//

import SwiftUI
import SQLite3

struct HomeScreen: View {
    @State private var moodValue: Int = 3 // Default mood value
    @State private var message: String = "" // Feedback message to the user
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How are you feeling today?")
                .font(.title)
                .padding()
            
            Stepper(value: $moodValue, in: 1...5) {
                Text("Mood: \(moodValue)")
                    .font(.headline)
            }
            .padding()
            
            Button(action: saveMood) {
                Text("Save Mood")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if !message.isEmpty {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }
    
    func saveMood() {
        let databasePath = Bundle.main.path(forResource: "activities-3", ofType: "db")
        guard let path = databasePath else {
            message = "Database not found."
            return
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) != SQLITE_OK {
            message = "Unable to open database."
            return
        }
        
        defer {
            sqlite3_close(db)
        }
        
        // Get today's date in "yyyy-MM-dd" format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
        
        // SQL query to insert or replace the mood value for today's date
        let insertQuery = """
        INSERT INTO MoodEvaluation (Date, Mood)
        VALUES (?, ?)
        ON CONFLICT(Date)
        DO UPDATE SET Mood = excluded.Mood;
        """
        
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, todayDate, -1, nil) // Bind date
            sqlite3_bind_int(stmt, 2, Int32(moodValue))    // Bind mood value
            
            if sqlite3_step(stmt) == SQLITE_DONE {
                message = "Mood saved successfully!"
            } else {
                message = "Failed to save mood."
            }
        } else {
            message = "Failed to prepare statement."
        }
        
        sqlite3_finalize(stmt)
    }
}
