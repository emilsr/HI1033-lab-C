//
//  ScaledDataChart.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-06.
//

import SwiftUI
import Charts

struct MoodPredictionChart: View {
    let scaledData: [(month: String, distanceScaled: Double, activityScaled: Double)]
    let monthOrder: [String: Int]
    let months: [String]

    var body: some View {
        Chart {
            ForEach(scaledData, id: \.month) { data in
                LineMark(
                    x: .value("Month", monthOrder[data.month] ?? 0),
                    y: .value("Distance Scaled", data.distanceScaled)
                )
                .foregroundStyle(Color.green)
                .symbol(.circle)
                .interpolationMethod(.linear)

                
                LineMark(
                    x: .value("Month", monthOrder[data.month] ?? 0),
                    y: .value("Activity Scaled", data.activityScaled)
                )
                .symbol(.square)
                .interpolationMethod(.linear)
            }

            // Area between the lines
            ForEach(scaledData, id: \.month) { data in
                AreaMark(
                    x: .value("Month", monthOrder[data.month] ?? 0),
                    yStart: .value("Distance Scaled", data.distanceScaled),
                    yEnd: .value("Activity Scaled", data.activityScaled)
                )
            }
            .opacity(0.2) // Adjust opacity as needed
            .foregroundStyle(Color.green)
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
}
