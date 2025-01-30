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
            
        Spacer()
         Spacer()
            
            // App Logo
            Image("swipper")
                .resizable()
                .scaledToFit() // Fyll hela rektangeln
                .frame(width: 200, height: 250) // Minska höjden för att ge mer utrymme till texten
                .clipShape(RoundedRectangle(cornerRadius: 36)) // Behåll rundade hörn
                .shadow(color: .gray.opacity(0.4), radius: 30, x: 0, y: 4)
                .padding(.bottom, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 36)
                        .stroke(Color.gray, lineWidth: 2)
                        .rotationEffect(.degrees(180)) // Rotera endast ramen
                )
            Spacer()



            
            // Login Title
            Text("LOGIN")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .padding(.bottom, 16)
            
            // Error Message
            if let error = todofb.loginerror {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.bottom, 8)
            }
            
            // Email and Password Section
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color(UIColor.systemGray6).opacity(0.4))
            .cornerRadius(16)
            .shadow(radius: 5)
            .padding(.horizontal)
            
            // Login Button
                                       
            Button(action: {
                todofb.userLogin(email: email, password: password)
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.9), Color.black]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal)
            .padding(.top, 16)

            // Register Button
            Button(action: {
                todofb.userRegister(email: email, password: password)
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.9), Color.black]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

                                           
            }
            .padding(.horizontal)
            .padding(.top, 8)
            

                                       
                                       
                                       
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
       

                               
}

#Preview {
    LoginView()
}
