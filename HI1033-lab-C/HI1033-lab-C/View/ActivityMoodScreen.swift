//
//  ActivityMoodScreen.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//
import SwiftUI


struct ActivityMoodScreen: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Number of Activitys")
                    .font(.headline)

                ActivityChart(
                    groupedActivities: viewModel.groupedActivities(),
                    monthOrder: viewModel.getMonthOrder(),
                    months: viewModel.getMonths()
                )
                .frame(height: 300)
                .padding(.horizontal)

                Text("Total Distance")
                    .font(.headline)

                DistanceChart(
                    groupedDistances: viewModel.groupedDistances(),
                    monthOrder: viewModel.getMonthOrder(),
                    months: viewModel.getMonths()
                )
                .frame(height: 300)
                .padding(.horizontal)

                Text("Average Monthly Mood")
                    .font(.headline)

                MoodChart(
                    moods: viewModel.moods,
                    monthOrder: viewModel.getMonthOrder(),
                    months: viewModel.getMonths()
                )
                .frame(height: 300)
                .padding(.horizontal)
                
                Text("Average Monthly Mood Prediction")
                                    .font(.headline)

                                MoodPredictionChart(
                                    scaledData: viewModel.getScaledData(),
                                    monthOrder: viewModel.getMonthOrder(),
                                    months: viewModel.getMonths()
                                )
                                .frame(height: 300)
                                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear(perform: viewModel.loadData)
        .navigationTitle("Activity & Mood")
    }
}
