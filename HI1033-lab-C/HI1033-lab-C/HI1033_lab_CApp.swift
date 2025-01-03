//
//  HI1033_lab_CApp.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-02.
//

import SwiftUI
import SQLite3

struct MainPage: View {
    var body: some View {
        NavigationView {
            TabView {
                HomeScreen()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                ActivityMoodScreen()
                    .tabItem {
                        Label("Activity & Mood", systemImage: "list.dash")
                    }
            }
        }
    }
}

struct HomeScreen: View {
    var body: some View {
        Text("Welcome to the Home Screen")
            .font(.largeTitle)
            .padding()
    }
}

struct ActivityMoodScreen: View {
    @State private var activities: [Activity] = []
    @State private var moods: [Mood] = []

    var body: some View {
        VStack {
            List(activities) { activity in
                VStack(alignment: .leading) {
                    Text("\(activity.month) - \(activity.activityType)")
                        .font(.headline)
                    Text("Value: \(activity.value)")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Activities")

            List(moods) { mood in
                VStack(alignment: .leading) {
                    Text("Date: \(mood.date)")
                        .font(.headline)
                    Text("Mood: \(mood.mood)")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Mood Evaluations")
        }
        .onAppear(perform: loadData)
    }

    func loadData() {
        let databasePath = Bundle.main.path(forResource: "activities-3", ofType: "db")
        guard let path = databasePath else {
            print("Database not found.")
            return
        }

        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("Unable to open database.")
            return
        }

        defer {
            sqlite3_close(db)
        }

        // Load activities
        let activityQuery = "SELECT Month, ActivityType, Value FROM Activities"
        var activityStmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, activityQuery, -1, &activityStmt, nil) == SQLITE_OK {
            while sqlite3_step(activityStmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(activityStmt, 0))
                let activityType = String(cString: sqlite3_column_text(activityStmt, 1))
                let value = sqlite3_column_int(activityStmt, 2)

                activities.append(Activity(id: UUID(), month: month, activityType: activityType, value: Int(value)))
            }
        } else {
            print("Failed to fetch activities.")
        }

        sqlite3_finalize(activityStmt)

        // Load moods
        let moodQuery = "SELECT Date, Mood FROM MoodEvaluation"
        var moodStmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, moodQuery, -1, &moodStmt, nil) == SQLITE_OK {
            while sqlite3_step(moodStmt) == SQLITE_ROW {
                let date = String(cString: sqlite3_column_text(moodStmt, 0))
                let mood = sqlite3_column_int(moodStmt, 1)

                moods.append(Mood(id: UUID(), date: date, mood: Int(mood)))
            }
        } else {
            print("Failed to fetch moods.")
        }

        sqlite3_finalize(moodStmt)
    }
}

struct Activity: Identifiable {
    let id: UUID
    let month: String
    let activityType: String
    let value: Int
}

struct Mood: Identifiable {
    let id: UUID
    let date: String
    let mood: Int
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
        }
    }
}
