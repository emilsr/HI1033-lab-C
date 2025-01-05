import SwiftUI
import SQLite3
import Charts

/*
func getWritableDatabasePath() -> String? {
    let fileManager = FileManager.default

    // Get the Documents directory path
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }

    let writableDatabasePath = documentsDirectory.appendingPathComponent("activities-3.db").path

    // Check if the database file already exists in the Documents directory
    if !fileManager.fileExists(atPath: writableDatabasePath) {
        // Get the database path in the app bundle
        guard let bundledDatabasePath = Bundle.main.path(forResource: "activities-3", ofType: "db") else {
            print("Database not found in the bundle.")
            return nil
        }

        do {
            // Copy the database to the writable directory
            try fileManager.copyItem(atPath: bundledDatabasePath, toPath: writableDatabasePath)
            print("Database copied to writable directory.")
        } catch {
            print("Failed to copy database: \(error.localizedDescription)")
            return nil
        }
    }
    print("File path:" + writableDatabasePath)
    return writableDatabasePath
}


//######## View ########
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
        guard let writableDatabasePath = getWritableDatabasePath() else {
            message = "Database path not found."
            return
        }

        var db: OpaquePointer? = nil
        if sqlite3_open(writableDatabasePath, &db) != SQLITE_OK {
            message = "Unable to open database."
            return
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
    }


    

}

struct TotalDistance: Identifiable {
    let id: UUID
    let month: String
    let distance: Int
    let activityType: String
}

struct Activity: Identifiable {
    let id: UUID
    let month: String
    let activityType: String
    let value: Int
}

struct MonthlyMood: Identifiable {
    let id: UUID
    let month: String
    let averageMood: Double
}

struct ActivityMoodScreen: View {
    @State private var activities: [Activity] = []
    @State private var moods: [MonthlyMood] = []
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

                Text("Average Monthly Mood")
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
        .chartLegend(position: .top)
    }
    
    private var moodChart: some View {
        Chart {
            ForEach(moods) { mood in
                LineMark(
                    x: .value("Month", monthOrder[mood.month] ?? 0),
                    y: .value("Average Mood", mood.averageMood)
                )
                .foregroundStyle(Color.blue)
                
                PointMark(
                    x: .value("Month", monthOrder[mood.month] ?? 0),
                    y: .value("Average Mood", mood.averageMood)
                )
                .foregroundStyle(Color.blue)
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
        .chartYScale(domain: 0...5)
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
        let activityQuery = "SELECT Month, ActivityType, Value FROM Activities"
        var activityStmt: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, activityQuery, -1, &activityStmt, nil) == SQLITE_OK {
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
                
                distances.append(TotalDistance(
                    id: UUID(),
                    month: month,
                    distance: Int(distance),
                    activityType: activityType
                ))
            }
        } else {
            print("Failed to fetch distances.")
        }
        
        sqlite3_finalize(distanceStmt)

        // Load moods with monthly averaging and all months included
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
        } else {
            print("Failed to fetch moods.")
        }

        sqlite3_finalize(moodStmt)
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
        }
    }
}
*/
