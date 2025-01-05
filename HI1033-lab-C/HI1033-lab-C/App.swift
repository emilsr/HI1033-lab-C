//
//  App.swift
//  HI1033-lab-C
//
//  Created by Emil Stener  on 2025-01-05.
//
/*
import SwiftUI

@main
struct HI1033LabCApp: App {
    // Create instances of our view models that will be shared across the app
    @StateObject private var activityViewModel = ActivityViewModel()
    @StateObject private var moodViewModel = MoodViewModel()
    
    init() {
        // Perform any initial setup here, such as configuring appearance
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            MainPage()
                // Inject our view models into the environment so they can be accessed by child views
                .environmentObject(activityViewModel)
                .environmentObject(moodViewModel)
        }
    }
    
    private func configureAppearance() {
        // Configure navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .systemBackground
        
        // Apply the appearance settings
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

// Preview provider for SwiftUI previews
#Preview {
    MainPage()
        .environmentObject(ActivityViewModel())
        .environmentObject(MoodViewModel())
}
*/
