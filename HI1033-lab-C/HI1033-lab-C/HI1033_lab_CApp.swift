//
//  HI1033_lab_CApp.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-02.
//

import SwiftUI
import SQLite3

struct HI1033_lab_CTests: View {
    @State private var moodScore: Int = 3
    @State private var message: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("How are you feeling today?")
                .font(.headline)

            Slider(value: Binding(
                get: { Double(moodScore) },
                set: { moodScore = Int($0) }
            ), in: 1...5, step: 1)
                .padding()

            Text("Mood Score: \(moodScore)")

            Button(action: {
                saveMood(score: moodScore)
            }) {
                Text("Save Mood")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Text(message)
                .foregroundColor(.green)
                .padding()

            Spacer()
        }
        .padding()
        .onAppear(perform: setupDatabase)
    }

    func saveMood(score: Int) {
        let date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)

        if let db = Database.shared.db {
            let insertOrUpdateQuery = "INSERT INTO Mood (date, score) VALUES (?, ?) ON CONFLICT(date) DO UPDATE SET score = excluded.score;"
            var statement: OpaquePointer?

            if sqlite3_prepare_v2(db, insertOrUpdateQuery, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, date, -1, nil)
                sqlite3_bind_int(statement, 2, Int32(score))

                if sqlite3_step(statement) == SQLITE_DONE {
                    message = "Mood saved successfully!"
                } else {
                    message = "Failed to save mood."
                }
            } else {
                message = "Error preparing statement."
            }

            sqlite3_finalize(statement)
        }
    }

    func setupDatabase() {
        _ = Database.shared
    }
}

class Database {
    static let shared = Database()
    var db: OpaquePointer?

    private init() {
        let fileManager = FileManager.default

        // Path to the database file
        let fileURL = try! fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("MoodTracker.sqlite")

        // Check if the database file exists
        if fileManager.fileExists(atPath: fileURL.path) {
            // Delete the existing file
            do {
                try fileManager.removeItem(at: fileURL)
                print("Old database deleted.")
            } catch {
                print("Failed to delete old database: \(error)")
            }
        }

        // Open or create the SQLite database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        } else {
            // Create the table with the UNIQUE constraint on the `date` column
            let createTableQuery = """
                CREATE TABLE IF NOT EXISTS Mood (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    date TEXT NOT NULL UNIQUE,
                    score INTEGER
                );
            """
            if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
                print("Error creating table")
            } else {
                print("Database created successfully at \(fileURL.path)")
            }
        }
    }

    deinit {
        sqlite3_close(db)
    }
}


@main
struct MoodTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ActivityGraphScreen()
            //HI1033_lab_CTests()
        }
    }
}
