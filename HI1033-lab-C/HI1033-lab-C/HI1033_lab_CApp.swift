import SwiftUI
import SQLite3
import Charts


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

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
        }
    }
}
