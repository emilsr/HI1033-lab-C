//
//  ScaledDataChart.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-06.
//

import SwiftUI
import Charts

struct ScaledDataChart: View {
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
                .symbol(.circle) // Use .circle symbol for the line

                LineMark(
                    x: .value("Month", monthOrder[data.month] ?? 0),
                    y: .value("Activity Scaled", data.activityScaled)
                )
                .foregroundStyle(Color.red)
                .symbol(.square) // Use .square symbol for the second line
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
}
