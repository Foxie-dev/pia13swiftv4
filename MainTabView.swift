//
//  TabView.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-20.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection: Tab = .dashboard

    // för att benämna taben/ olika taggar
    enum Tab {
        case dashboard
        case list
        case profile
    }
    
    
    var body: some View {
        TabView(selection: $selection) {
           TodoView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
                .tag(Tab.dashboard)
                .background(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom))
            
            
            ListView()
                 .tabItem {
                     Label("List", systemImage: "list.bullet")
                 }
                 .tag(Tab.list)
                 .background(LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom)) // Different background

            
            
            ProfileView()
                 .tabItem {
                     Label("Profile", systemImage: "person")
                 }
                 .tag(Tab.profile)
                    .background(LinearGradient(gradient: Gradient(colors: [.green.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom)) // Different background
            
        }//Tabview
        
        .accentColor(.black) // Matches the black-and-red theme
                .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.all)) // Background for the entire TabView
    }
    
    
}

#Preview {
    MainTabView()
}
