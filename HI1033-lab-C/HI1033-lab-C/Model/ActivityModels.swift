//
//  ActivityModel.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import Foundation

struct Activity: Identifiable {
    let id: UUID
    let month: String
    let activityType: String
    let value: Int
}

struct TotalDistance: Identifiable {
    let id: UUID
    let month: String
    let distance: Int
    let activityType: String
}

// Enum for activity types to ensure consistency
enum ActivityType: String, CaseIterable {
    case running = "Running"
    case cycling = "Cycling"
    case swimming = "Swimming"
    case walking = "Walking"
    
    var icon: String {
        switch self {
        case .running:
            return "figure.run"
        case .cycling:
            return "figure.outdoor.cycle"
        case .swimming:
            return "figure.pool.swim"
        case .walking:
            return "figure.walk"
        }
    }
}
