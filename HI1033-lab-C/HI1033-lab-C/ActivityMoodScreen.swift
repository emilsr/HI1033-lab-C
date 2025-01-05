//
//  ActivityMoodScreen.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

/*
import SwiftUI
import Charts

struct ActivityMoodScreen: View {
    @State private var activities: [Activity] = []
    @State private var moods: [MonthlyMood] = []
    @State private var distances: [TotalDistance] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Activity Data")
                    .font(.headline)

                activityChart
                    .frame(height: 300)
                    .padding(.horizontal)
                
                Text("Total Distance")
                    .font(.headline)
                
                distanceChart
                    .frame(height: 300)
                    .padding(.horizontal)

                Text("Average Monthly Mood")
                    .font(.headline)

                moodChart
                    .frame(height: 300)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear(perform: loadData)
        .navigationTitle("Activity & Mood")
    }

    private var activityChart: some View {
        Chart {
            ForEach(groupedActivities(), id: \.key) { activityType, data in
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
    
    private var distanceChart: some View {
        Chart {
            ForEach(groupedDistances(), id: \.key) { month, data in
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
        .chartLegend(position: .top)
    }
    
    private var moodChart: some View {
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
*/
