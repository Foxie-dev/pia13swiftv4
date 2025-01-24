//
//  ContentView.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-02.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct ContentView: View {
    
    @State var isLoggedin : Bool?
    
    var body: some View {
        VStack {
            if isLoggedin == true {
               // TodoView()
                MainTabView()
            }
            if isLoggedin == false {
                LoginView()
            }
        }
        .onAppear() {
            Auth.auth().addStateDidChangeListener { auth, user in
                print("USER CHANGE")
                
                if Auth.auth().currentUser == nil {
                    isLoggedin = false
                } else {
                    isLoggedin = true
                }
                
            }
        }
    }
    
    
}

#Preview {
    ContentView()
}
