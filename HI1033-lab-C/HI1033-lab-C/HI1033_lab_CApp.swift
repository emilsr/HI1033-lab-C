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

struct TotalDistance: Identifiable {
    let id: UUID
    let month: String
    let distance: Int
    let activityType: String
}

struct ActivityMoodScreen: View {
    @State private var activities: [Activity] = []
    @State private var moods: [Mood] = []
    @State private var distances: [TotalDistance] = []

    private let monthOrder: [String: Int] = [
        "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
        "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12
    ]
    
    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Activity Data")
                    .font(.headline)

                activityChart
                    .frame(height: 300)
                    .padding(.horizontal)
                
                Text("Total Distance")
                    .font(.headline)
                
                distanceChart
                    .frame(height: 300)
                    .padding(.horizontal)

                Text("Mood Data")
                    .font(.headline)

                moodChart
                    .frame(height: 300)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear(perform: loadData)
        .navigationTitle("Activity & Mood")
    }

    private var activityChart: some View {
        Chart {
            ForEach(groupedActivities(), id: \.key) { activityType, data in
                ForEach(data, id: \.month) { activity in
                    LineMark(
                        x: .value("Month", monthOrder[activity.month] ?? 0),
                        y: .value("Value", activity.value)
                    )
                    .foregroundStyle(by: .value("Activity Type", activityType))
                    
                    PointMark(
                        x: .value("Month", monthOrder[activity.month] ?? 0),
                        y: .value("Value", activity.value)
                    )
                    .foregroundStyle(by: .value("Activity Type", activityType))
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: 1)) { value in
                if let month = value.as(Int.self),
                   month >= 1 && month <= 12 {
                    AxisValueLabel {
                        Text(months[month - 1])
                    }
                }
            }
        }
    }
    
    private var distanceChart: some View {
        Chart {
            ForEach(groupedDistances(), id: \.key) { month, data in
                ForEach(data) { distance in
                    BarMark(
                        x: .value("Month", monthOrder[distance.month] ?? 0),
                        y: .value("Distance", distance.distance)
                    )
                    .foregroundStyle(by: .value("Activity Type", distance.activityType))
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: 1)) { value in
                if let month = value.as(Int.self),
                   month >= 1 && month <= 12 {
                    AxisValueLabel {
                        Text(months[month - 1])
                    }
                }
            }
        }
        .chartLegend(position: .top) // Optional: Add a legend
    }
    
    private var moodChart: some View {
        Chart(moods) { mood in
            LineMark(
                x: .value("Date", mood.date),
                y: .value("Mood", mood.mood)
            )
            
            PointMark(
                x: .value("Date", mood.date),
                y: .value("Mood", mood.mood)
            )
        }
    }

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
        
        // Load total distances
        let distanceQuery = "SELECT Month, Distance, ActivityType FROM TotalDistance"
        var distanceStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, distanceQuery, -1, &distanceStmt, nil) == SQLITE_OK {
            while sqlite3_step(distanceStmt) == SQLITE_ROW {
                let month = String(cString: sqlite3_column_text(distanceStmt, 0))
                let distance = sqlite3_column_int(distanceStmt, 1)
                let activityType = String(cString: sqlite3_column_text(distanceStmt, 2))
                
                distances.append(TotalDistance(id: UUID(), month: month, distance: Int(distance), activityType: activityType))
            }
        } else {
            print("Failed to fetch distances.")
        }
        
        sqlite3_finalize(distanceStmt)

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
