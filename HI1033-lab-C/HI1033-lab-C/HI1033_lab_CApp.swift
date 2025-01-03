import SwiftUI
import SQLite3
import Charts

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

    // Map month names to their corresponding numerical values
    private let monthOrder: [String: Int] = [
        "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
        "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12
    ]

    var body: some View {
        ScrollView {
            VStack {
                Text("Activity Data")
                    .font(.headline)

                Chart {
                    ForEach(groupedActivities(), id: \.key) { activityType, data in
                        ForEach(data.sorted(by: {
                            (monthOrder[$0.month] ?? 0) < (monthOrder[$1.month] ?? 0)
                        }), id: \.month) { activity in
                            LineMark(
                                x: .value("Month", activity.month),
                                y: .value("Value", activity.value)
                            )
                            .foregroundStyle(by: .value("Activity Type", activityType))
                        }
                    }
                }
                .frame(height: 300)

                Text("Mood Data")
                    .font(.headline)

                Chart(moods) { mood in
                    LineMark(
                        x: .value("Date", mood.date),
                        y: .value("Mood", mood.mood)
                    )
                }
                .frame(height: 300)
            }
        }
        .onAppear(perform: loadData)
        .navigationTitle("Activity & Mood")
    }

    // Group activities by type and sort them by the numerical month value
    func groupedActivities() -> [(key: String, value: [Activity])] {
        // Sort the activities by their month using the monthOrder dictionary
        return Dictionary(grouping: activities, by: { $0.activityType })
            .sorted(by: { $0.key < $1.key })
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
