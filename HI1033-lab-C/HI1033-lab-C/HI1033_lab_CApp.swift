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
            let insertQuery = "INSERT INTO Mood (date, score) VALUES (?, ?);"
            var statement: OpaquePointer?

            if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
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
        let fileURL = try! FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("MoodTracker.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        } else {
            let createTableQuery = "CREATE TABLE IF NOT EXISTS Mood (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, score INTEGER);"

            if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
                print("Error creating table")
            }
            print("Database path: \(fileURL.path)")

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
            HI1033_lab_CTests()
        }
    }
}
