//
//  MonthlyMoodModels.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import Foundation

struct MonthlyMood: Identifiable {
    let id: UUID
    let month: String
    let averageMood: Double
}

struct DailyMood: Identifiable {
    let id: UUID
    let date: Date
    let mood: Int
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// Enum for mood values to ensure consistency
enum MoodValue: Int, CaseIterable {
    case veryBad = 1
    case bad = 2
    case neutral = 3
    case good = 4
    case veryGood = 5
    
    var description: String {
        switch self {
        case .veryBad:
            return "Very Bad"
        case .bad:
            return "Bad"
        case .neutral:
            return "Neutral"
        case .good:
            return "Good"
        case .veryGood:
            return "Very Good"
        }
    }
    
    var icon: String {
        switch self {
        case .veryBad:
            return "😢"
        case .bad:
            return "☹️"
        case .neutral:
            return "😐"
        case .good:
            return "🙂"
        case .veryGood:
            return "😄"
        }
    }
}
