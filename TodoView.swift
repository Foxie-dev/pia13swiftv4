//
//  TodoView.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-04.
//

import SwiftUI
import PhotosUI

struct TodoView: View {
    
    @State var todofb = TodoFB()
    @State var todoadd = ""
    
    @State var showCamera = false
    @State var image: UIImage? // För att lagra vald bild
    
    var body: some View {
        // Step 1: Wrap the view in a NavigationView
        NavigationView {
            VStack {
                // Logout Button
                Button(action: {
                    todofb.userLogout()
                }) {
                    Text("Logout")
                }
                
                
                // Step 2: Add NavigationLink to navigate to TestaStorageView
                NavigationLink(destination: TestaStorageView()) {
                    Text("Go to Storage Test")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top)
                }
                
                
                HStack {
                    // TextField for Todo
                    TextField("TODO", text: $todoadd)
                    
                    // Button to show camera
                    /*Button(action: {
                        showCamera.toggle()
                    }) {
                        Text("CAMERA")
                    } */
                    
                    // Button to save the todo
                    Button(action: {
                        todofb.todosave(todoadd: todoadd)
                    }) {
                        Text("ADD")
                    }
                }
                
                // List of todo items
                List(todofb.todolist, id: \.id) { todoitem in
                    HStack {
                        VStack {
                            Text(todoitem.title)
                            Text("DASHBOARD")
                        }
                        
                        Spacer()
                        
                        // Delete button for each todo
                        Button(action: {
                            todofb.tododelete(todoitem: todoitem)
                        }) {
                            Text("Delete")
                        }
                    }
                }
                
         
            }
            .padding()
            .onAppear {
                Task {
                    await todofb.todoload()
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(image: $image, onSave: saveImageToGallery)
            }
        }
    }
    
    // Function to save the image to the gallery
    func saveImageToGallery(image: UIImage?) {
        guard let image = image else { return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            if success {
                print("Bild sparad i galleriet!")
            } else if let error = error {
                print("Fel vid sparande: \(error.localizedDescription)")
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onSave: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
                parent.onSave(selectedImage) // Save the image to the gallery
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    TodoView()
}
