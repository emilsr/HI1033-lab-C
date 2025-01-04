//
//  Model.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-04.
//

import Foundation

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
