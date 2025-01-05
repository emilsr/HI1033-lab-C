//
//  MoodChart.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import SwiftUI
import Charts

struct MoodChart: View {
    let moods: [MonthlyMood]
    let monthOrder: [String: Int]
    let months: [String]

    var body: some View {
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
}
