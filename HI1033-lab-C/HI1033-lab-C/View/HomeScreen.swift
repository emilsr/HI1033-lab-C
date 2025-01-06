//
//  HomeScreen.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//

import SwiftUI

struct HomeScreen: View {
    @State private var moodValue: Int = 3 // Default mood value
    @State private var message: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How are you feeling today?")
                .font(.title)
                .padding()
            
            Stepper(value: $moodValue, in: 1...5) {
                Text("Mood: \(moodValue)")
                    .font(.headline)
            }
            .padding()
            
            Button(action: {
                message =  DatabaseManager.shared.saveMood(moodValue: moodValue)  // Pass the moodValue to saveMood
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
