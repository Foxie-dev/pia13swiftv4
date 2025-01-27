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
            
            Image("Blackredcards")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .shadow(radius: 200)
                .padding(.bottom, 8)
            
            Text("LOGIN")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
                .padding(.bottom, 16)
            
            if let error = todofb.loginerror {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.bottom, 8)
            }
            
            TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .padding(.horizontal)

                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .padding(.top, 8)

                
                // Login button
            Button(action: {
                todofb.userLogin(email: email, password: password)
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .scaleEffect(1.0)
            }
            .padding(.horizontal)
            }
    
        
        // Register button
                 Button(action: {
                     todofb.userRegister(email: email, password: password)
                 }) {
                     Text("Register")
                         .frame(maxWidth: .infinity)
                         .padding()
                         .background(Color.black)
                         .foregroundColor(.white)
                         .cornerRadius(8)
                 }
                 .padding(.horizontal)
             }

}

#Preview {
    LoginView()
}
