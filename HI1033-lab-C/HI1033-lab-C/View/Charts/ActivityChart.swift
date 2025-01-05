//
//  moodChart.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import SwiftUI
import Charts

struct ActivityChart: View {
    let groupedActivities: [(key: String, value: [Activity])]
    let monthOrder: [String: Int]
    let months: [String]

    var body: some View {
        Chart {
            ForEach(groupedActivities, id: \.key) { activityType, data in
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
}
