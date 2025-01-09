//
//  ContentView.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-02.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var todoadd = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("TODO", text: $todoadd)
                Button(action: {
                    todosave()
                }) {
                    Text("ADD")
                }
            }
        }
        .padding()
        .onAppear() {
            //fbtest()
        }
        .task {
            //await fbtestload()
            await todoload()
        }
    }
    func todoload() async {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        do {
            let tododata = try await ref.child("todo").getData()
            print(tododata.childrenCount)
            
            for todoitem in tododata.children {
                print("En todo sak")
                let todosnap = todoitem as!DataSnapshot
               // let todotitle = todosnap.child("title").value as? Sring
                
                //print(todotitle)
            }
            
        } catch {
            // Något gick fel
            print("Nu blev det fel!!")
        }
    }
    
    func todosave() {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        ref.child("todo").childByAutoId().child("title").setValue(todoadd)
    }
    
    func fbtestsave() {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        ref.child("fruit").setValue("orange")
        
    }
    
    func fbtestload() async {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        do {
            let namndata = try await ref.child("namn").getData()
            if let thename = namndata.value as? String {
                print(thename)
            }
            
        } catch {
            // Något gick fel
            print("Nu blev det fel!!")
        }
        
        #Preview {
            ContentView()
        }
    }
}
