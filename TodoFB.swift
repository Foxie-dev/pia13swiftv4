//
//  TodoFB.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-04.
//
// Designa och måla på slutet

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

@Observable class TodoFB {
    
    var loginerror : String?
    var todolist = [Todo]()
    
    func userLogin(email : String, password : String) {
        Task {
            do {
                try await Auth.auth().signIn(withEmail: email, password: password)
            } catch {
                print("FEL LOGIN")
                loginerror = "Error login"
            }
        }
    }
    
    func userRegister(email : String, password : String) {
        Task {
            do {
                let regResult = try await Auth.auth().createUser(withEmail: email, password: password)
                
                
            } catch {
                print("FEL REG")
                loginerror = "Error reg"
            }
        }
    }
    
    func userLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    func todoload() async {
        
        let userid = Auth.auth().currentUser!.uid
        
        //let userid = "p7UeB2s3cdb6FET01Od51aMwYg22"
        
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        todolist = []
        
        do {
            let tododata = try await ref.child("todolist").child(userid).getData()
            print(tododata.childrenCount)
            
            for todoitem in tododata.children {
                let todosnap = todoitem as! DataSnapshot
                
                let tododict = todosnap.value as? [String: Any]
                
                
                print(tododict!["title"])
                
                var faketodo = Todo()
                faketodo.id = todosnap.key
                faketodo.title = tododict!["title"] as! String
                
                todolist.append(faketodo)
                
            }
            
        } catch {
            // Något gick fel
            print("Nu blev det fel!!!")
        }
    }
    
    func todosave(todoadd : String) {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        let userid = Auth.auth().currentUser!.uid
        
        var savedata = [String : Any]()
        savedata["title"] = todoadd
        savedata["done"] = false

        
        ref.child("todolist").child(userid).childByAutoId().setValue(savedata)

        

        Task {
            await todoload()
        }
    }
    
    func tododelete(todoitem : Todo) {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        let userid = Auth.auth().currentUser!.uid
        
        ref.child("todolist").child(userid).child(todoitem.id).removeValue()
        
        Task {
            await todoload()
        }
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
            print("Nu blev det fel!!!")
        }
    }
}
