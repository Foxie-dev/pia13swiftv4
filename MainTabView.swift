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
            
            ListView()
                 .tabItem {
                     Label("List", systemImage: "list.bullet")
                 }
                 .tag(Tab.list)
            
            ProfileView()
                 .tabItem {
                     Label("Profile", systemImage: "person")
                 }
                 .tag(Tab.profile)
        }//Tabview
    }
    
    
}

#Preview {
    MainTabView()
}
