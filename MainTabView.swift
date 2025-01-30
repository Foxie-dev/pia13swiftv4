//
//  TabView.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-20.
//

//
// TabView.swift
// pia13swiftv4
//
// Created by Elia Johannes on 2025-01-20.
//

import SwiftUI
struct MainTabView: View {
  @State private var selection: Tab = .dashboard
  // för att benämna taben/ olika taggar
  enum Tab {
    case dashboard
    case topimages // Changed from 'list' to 'topimages'
    case gallerycamera // Changed from 'profile' to 'gallerycamera'
  }
    
  var body: some View {
      ZStack(alignment: .topTrailing) {
          TabView(selection: $selection) {
              CardView6()
                  .tabItem {
                      Label("Dashboard", systemImage: "house")
                  }
                  .tag(Tab.dashboard)
                  .background(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom))
              
              SView()
                  .tabItem {
                      Label("Topimages", systemImage: "list.bullet") // Changed from 'List' to 'Topimages'
                  }
                  .tag(Tab.topimages) // Changed from 'list' to 'topimages'
                  .background(LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom)) // Different background
              
              itest2()
                  .tabItem {
                      Label("GalleryCamera", systemImage: "camera") // Changed from 'Profile' to 'GalleryCamera'
                  }
                  .tag(Tab.gallerycamera) // Changed from 'profile' to 'gallerycamera'
                  .background(LinearGradient(gradient: Gradient(colors: [.green.opacity(0.1), .white]), startPoint: .top, endPoint: .bottom)) // Different background
              
              
              
              
          }//Tabview
          .accentColor(.black) // Matches the black-and-red theme
          .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.all)) // Background for the entire TabView
      
          
          
          // Logout Button in Top Right Corner
          ZStack {
              VStack {
                  HStack {
                      Spacer() // Trycker knappen till höger
                      Button(action: {
                          TodoFB().userLogout()
                      }) {
                          Image(systemName: "power") // Ström/Logout-ikon
                              .font(.system(size: 20, weight: .bold)) // Storlek och vikt
                              .foregroundColor(.white)
                              .padding()
                              .background(
                                  LinearGradient(
                                      gradient: Gradient(colors: [Color.gray.opacity(0.9), Color.black]),
                                      startPoint: .top,
                                      endPoint: .bottom
                                  )
                              )
                              .clipShape(Circle()) // Gör knappen rund
                              .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                      }
                      .padding() // Lägger till lite space från kanten
                  }
                  Spacer() // Trycker resten av innehållet nedåt
              }
          }

      }
  }
}




#Preview {
  MainTabView()
}
