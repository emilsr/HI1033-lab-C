//
//  ActivityScreen.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

/*
import SwiftUI
import SQLite3
import Charts

struct ActivityMoodScreen: View {
    @StateObject private var viewModel = ActivityMoodViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Activity Data")
                    .font(.headline)
                
                ActivityChart(viewModel: viewModel)
                    .frame(height: 300)
                    .padding(.horizontal)
                
                Text("Total Distance")
                    .font(.headline)
                
                DistanceChart(viewModel: viewModel)
                    .frame(height: 300)
                    .padding(.horizontal)
                
                Text("Average Monthly Mood")
                    .font(.headline)
                
                MoodChart(viewModel: viewModel)
                    .frame(height: 300)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear(perform: viewModel.loadData)
        .navigationTitle("Activity & Mood")
    }
}

struct ActivityChart: View {
    @ObservedObject var viewModel: ActivityMoodViewModel
    
    var body: some View {
        Chart {
            ForEach(viewModel.groupedActivities(), id: \.key) { activityType, data in
                ForEach(data, id: \.month) { activity in
                    LineMark(
                        x: .value("Month", viewModel.monthOrder[activity.month] ?? 0),
                        y: .value("Value", activity.value)
                    )
                    .foregroundStyle(by: .value("Activity Type", activityType))
                    
                    PointMark(
                        x: .value("Month", viewModel.monthOrder[activity.month] ?? 0),
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
                        Text(viewModel.months[month - 1])
                    }
                }
            }
        }
    }
}

struct DistanceChart: View {
    @ObservedObject var viewModel: ActivityMoodViewModel
    
    var body: some View {
        Chart {
            ForEach(viewModel.groupedDistances(), id: \.key) { month, data in
                ForEach(data) { distance in
                    BarMark(
                        x: .value("Month", viewModel.monthOrder[distance.month] ?? 0),
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
                        Text(viewModel.months[month - 1])
                    }
                }
            }
        }
        .chartLegend(position: .top)
    }
}

struct MoodChart: View {
    @ObservedObject var viewModel: ActivityMoodViewModel
    
    var body: some View {
        Chart {
            ForEach(viewModel.moods) { mood in
                LineMark(
                    x: .value("Month", viewModel.monthOrder[mood.month] ?? 0),
                    y: .value("Average Mood", mood.averageMood)
                )
                .foregroundStyle(Color.blue)
                
                PointMark(
                    x: .value("Month", viewModel.monthOrder[mood.month] ?? 0),
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
                        Text(viewModel.months[month - 1])
                    }
                }
            }
        }
        .chartYScale(domain: 0...5)
    }
}
*/
