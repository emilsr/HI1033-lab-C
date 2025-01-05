//
//  MainPage.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-06.
//
import SwiftUI


struct MainPage: View {
    var body: some View {
        NavigationView {
            TabView {
                HomeScreen()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                ActivityMoodScreen()
                    .tabItem {
                        Label("Activity & Mood", systemImage: "list.dash")
                    }
            }
        }
    }
}
