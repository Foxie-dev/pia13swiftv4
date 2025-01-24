//
//  LoginView.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-04.
//

import SwiftUI

struct LoginView: View {
    
    @State var todofb = TodoFB()
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Text("LOGIN")
            
            if todofb.loginerror != nil {
                Text(todofb.loginerror!)
            }
            
            TextField("Email", text: $email)
            TextField("Password", text: $password)

            Button(action: {
                todofb.userLogin(email: email, password: password)
            }) {
                Text("Login")
            }
            Button(action: {
                todofb.userRegister(email: email, password: password)
            }) {
                Text("Register")
            }
        }
        .padding()
    }
    
    
    
}

#Preview {
    LoginView()
}
