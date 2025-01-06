//
//  DistanceChart.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import SwiftUI
import Charts

struct DistanceChart: View {
    let groupedDistances: [(key: String, value: [TotalDistance])]
    let monthOrder: [String: Int]
    let months: [String]

    var body: some View {
        Chart {
            ForEach(groupedDistances, id: \.key) { month, data in
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
        .chartLegend(position: .bottom)
    }
}
