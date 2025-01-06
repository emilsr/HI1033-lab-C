//
//  HomeScreen.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import SwiftUI

struct HomeScreen: View {
    @State private var moodValue: Double = 3.0 // Default mood value
    @State private var message: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How are you feeling today?")
                .font(.title)
                .padding()
            
            VStack {
                Text("Mood: \(Int(moodValue))") // Display the integer value of the mood
                    .font(.headline)
                
                Slider(value: $moodValue, in: 1...5, step: 1) // Mood value ranges from 1 to 5
                    .padding()
            }
            
            Button(action: {
                message = DatabaseManager.shared.saveMood(moodValue: Int(moodValue)) // Convert to Int before passing
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
