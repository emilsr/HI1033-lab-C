//
//  HomeScreen.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var moodViewModel: MoodViewModel
    @State private var message: String = "" // Feedback message to the user
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How are you feeling today?")
                .font(.title)
                .padding()
            
            Stepper(value: $moodViewModel.moodValue, in: 1...5) {
                HStack {
                    Text("Mood: \(moodViewModel.moodValue)")
                        .font(.headline)
                    Text(MoodValue(rawValue: moodViewModel.moodValue)?.icon ?? "")
                }
            }
            .padding()
            
            Button(action: {
                message = moodViewModel.saveMood()
            }) {
                Text("Save Mood")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if !message.isEmpty {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }
}
