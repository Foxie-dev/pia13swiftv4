//
//  TodoView.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-04.
//

import SwiftUI

struct TodoView: View {
    
    @State var todofb = TodoFB()
    @State var todoadd = ""
    
    var body: some View {
        VStack {
            
            Button(action: {
                todofb.userLogout()
            }) {
                Text("Logout")
            }
            
            HStack {
                TextField("TODO", text: $todoadd)
                Button(action: {
                    todofb.todosave(todoadd: todoadd)
                }) {
                    Text("ADD")
                }
            }
            
            List(todofb.todolist, id: \.id) { todoitem in
                HStack {
                    VStack {
                        Text(todoitem.title)
                        Text("DASHBOARD")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        todofb.tododelete(todoitem: todoitem)
                    }) {
                        Text("Delete")
                    }
                }
            }
            
        }
        .padding()
        .onAppear() {
            //fbtest()
            
            
        }
        .task {
            //await fbtestload()
            await todofb.todoload()
        }
    }
    
}

#Preview {
    TodoView()
}
