//
//  ActivityViewModel.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import SwiftUI

class ActivityMoodViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var moods: [MonthlyMood] = []
    @Published var distances: [TotalDistance] = []

    private let monthOrder: [String: Int] = [
        "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
        "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12
    ]

    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    func loadData() {
        activities = DatabaseManager.shared.fetchActivities()
        distances = DatabaseManager.shared.fetchDistances()
        moods = DatabaseManager.shared.fetchMoods()
        print("Moods: \(moods)")

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
    
    
    func getScaledData() -> [(month: String, distanceScaled: Double, activityScaled: Double)] {
        let distances = DatabaseManager.shared.fetchDistances()
        let activities = DatabaseManager.shared.fetchActivities()

        let distanceMap = Dictionary(grouping: distances, by: { $0.month }).mapValues {
            $0.reduce(0.0) { $0 + Double($1.distance) * 0.05 }
        }

        let activityMap = Dictionary(grouping: activities, by: { $0.month }).mapValues {
            $0.reduce(0.0) { $0 + Double($1.value) * 0.3 }
        }

        let allMonths = Set(distanceMap.keys).union(activityMap.keys)

        return allMonths.sorted(by: { getMonthOrder()[$0, default: 0] < getMonthOrder()[$1, default: 0] }).map { month in
            (
                month: month,
                distanceScaled: distanceMap[month] ?? 0.0,
                activityScaled: activityMap[month] ?? 0.0
            )
        }
    }


    func getMonths() -> [String] {
        return months
    }

    func getMonthOrder() -> [String: Int] {
        return monthOrder
    }
    
}
